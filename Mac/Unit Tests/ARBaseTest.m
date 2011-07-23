//
//  ARBaseTest.m
//  ActiveRecord
//
//  Created by Fjölnir Ásgeirsson on 8.8.2007.
//  Copyright 2007 ninja kitten. All rights reserved.
//

// TODO: Reset database for each test. (maybe use in memory database and fixtures)

#import "ARBaseTest.h"
#import <ActiveRecord/ActiveRecord.h>
#import "GHTestCase+Fixtures.h"

@implementation ARBase (PrefixSetter)
+ (void)load
{
  [self setClassPrefix:@"TE"]; // TE stands for test fyi
}
@end

@implementation ARBaseTest
- (void)setUp
{
	[super setUpSQLiteFixtures];
	//[super setUpMySQLFixtures];
}
- (void)testTableName
{
  GHAssertTrue([@"models" isEqualToString:[TEModel tableName]],
               @"TEModel's table name shouldn't be: %@", [TEModel tableName]);
}
- (void)testCreate
{
  TEModel *model = [TEModel createWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Foobar", @"name",
                                                  @"This is great!", @"info", nil]];

	GHAssertEqualObjects(@"Foobar", [model name], @"Couldn't create model!");
	GHAssertEqualObjects(@"This is great!", [model info], @"Couldn't create model!");
}
- (void)testDestroy
{
	TEModel *model = [TEModel createWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Deletee", @"name",
                                                  @"This won't exist for long", @"info", nil]];
	NSUInteger theId = model.databaseId;
	GHAssertTrue([model destroy], @"Couldn't delete record");
	NSArray *result = [TEModel find:(ARFindSpecification)theId];
	GHAssertEquals([result count], (NSUInteger)0, @"The record wasn't actually deleted result: %@", result);
}
- (void)testFindFirst
{
  TEModel *first = [[TEModel find:ARFindFirst] objectAtIndex:0];
  
  GHAssertNotNil(first, @"No result for first entry!");
	GHAssertEqualObjects(@"a name", [first name] , @"The name of the first entry should be 'a name'");
}
- (void)testModifying
{
  TEModel *first = [[TEModel find:ARFindFirst] objectAtIndex:0];
  [first beginTransaction];
  NSString *newName = @"NOT THE SAME NAME!";
  //[first setName:newName];
	first.name = @"NOT THE SAME NAME!";
  [first endTransaction];
	GHAssertEqualObjects([first name] , newName , @"The new name apparently wasn't saved");
}
- (void)testHasMany
{
  // First test retrieving
  TEModel *model = [[TEModel find:ARFindFirst] objectAtIndex:0];
  NSArray *originalPeople = [model people];
  GHAssertTrue(([originalPeople count] == 2), @"TEModel should have 2 TEPeople but had %d", [originalPeople count]);

  // Then test sending
  TEPerson *aPerson = [TEPerson createWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"frankenstein", @"realName", @"frank", @"userName", nil]];
  [model addPerson:aPerson];
  NSMutableArray *laterPeople = [originalPeople mutableCopy];
  [laterPeople addObject:aPerson];
  
  
  GHAssertTrue([[model people] count] == [laterPeople count], @"person count should've been %d but was %d", [laterPeople count], [[model people] count]);

  [model setPeople:[NSArray arrayWithObject:aPerson]];
  GHAssertTrue([[model people] count] == 1, @"model should only have one person");
  GHAssertTrue([[[model people] objectAtIndex:0] databaseId] == [aPerson databaseId], @"person id should've been %d but was %d", [aPerson databaseId], [[[model people] objectAtIndex:0] databaseId]);
}
- (void)testHasManyThrough
{
  // First test retrieving
  TEModel *model = [[TEModel find:ARFindFirst] objectAtIndex:0];
	NSArray *belgians = [model belgians];
	NSLog(@"belgians: %@", belgians);
  GHAssertTrue(([belgians count] == 2), @"TEModel should have 2 belgians but had %d", [belgians count]);	
}

- (void)testHasOne
{
  TEModel *model   = [[TEModel find:ARFindFirst] objectAtIndex:0];
  TEAnimal *animal = [[TEAnimal find:ARFindAll] objectAtIndex:0];

  GHAssertTrue(([animal databaseId] == [[model animal] databaseId]), @"%@ != %@ !!", animal, [model animal]);
	return;
	
  // Then test sending
  TEAnimal *anAnimal = [TEAnimal createWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Leopard", @"species", @"Godfred", @"nickname", nil]];

  [model setAnimal:anAnimal];
  GHAssertTrue( ([[model animal] databaseId] == [anAnimal databaseId]), @"animal id was wrong (%d != %d)", [[model animal] databaseId], [anAnimal databaseId]);
}
- (void)testBelongsTo
{
  TEPerson *person = [[TEPerson find:ARFindFirst] objectAtIndex:0];
  TEModel *model = [person model];

  GHAssertNotNil(model, @"No model found for person!");
  
  // Then test sending
  TEAnimal *anAnimal = [TEAnimal createWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"cheetah", @"species", @"rick", @"nickname", nil]];
  
  TEAnimal *oldAnimal = [model animal];
  [anAnimal setModel:model];
  
  GHAssertTrue(([[anAnimal model] databaseId] == [model databaseId]), @"model id was wrong (%d != %d)", [[anAnimal model] databaseId], [model databaseId]);
  [model setAnimal:oldAnimal];
}
- (void)testHasAndBelongsToMany
{
  TEPerson *person = [[TEPerson find:3] objectAtIndex:0];
  TEAnimal *animal = [[TEAnimal find:ARFindFirst] objectAtIndex:0];
	GHAssertEquals([[[person animals] objectAtIndex:0] databaseId], (NSUInteger)1, @"Person had wrong animal!");
	GHAssertEquals([[[animal people] objectAtIndex:0] databaseId], (NSUInteger)3, @"Animal had wrong person!");
	animal = [[TEAnimal find:2] objectAtIndex:0];
	[animal addPerson:person];
	GHAssertEquals([[[animal people] objectAtIndex:0] databaseId], (NSUInteger)[person databaseId], @"Animal had wrong person!");
}
- (void)testDelayedWriting
{
	[ARBase setDelayWriting:YES];
	TEModel *model = [[TEModel find:ARFindFirst] objectAtIndex:0];
	[model setName:@"delayed"];
	GHAssertEqualObjects(@"a name", [model name], @"model name was saved prematurely!");
	[model save];
	GHAssertEqualObjects(@"delayed", [model name], @"model name was not saved!");
	[ARBase setDelayWriting:NO];
}
@end

@implementation TEModel
@dynamic name, info;
+ (void)initialize
{
  [[self relationships] addObject:[ARRelationshipHasMany relationshipWithName:@"people"]];
  [[self relationships] addObject:[ARRelationshipHasOne relationshipWithName:@"animal"]];
	[[self relationships] addObject:[ARRelationshipHasManyThrough relationshipWithName:@"belgians" through:@"people"]];

}
@end

@implementation TEPerson
@dynamic userName, realName;
+ (void)initialize
{
  [[self relationships] addObject:[ARRelationshipBelongsTo relationshipWithName:@"model"]];
  [[self relationships] addObject:[ARRelationshipHABTM relationshipWithName:@"animals"]];
	[[self relationships] addObject:[ARRelationshipHasMany relationshipWithName:@"belgians"]];
}

@end

@implementation TEAnimal
+ (void)initialize
{
  [[self relationships] addObject:[ARRelationshipBelongsTo relationshipWithName:@"model"]];
  [[self relationships] addObject:[ARRelationshipHABTM relationshipWithName:@"people"]];
}
@end

@implementation TEBelgian
+ (void)initialize
{
	[[self relationships] addObject:[ARRelationshipBelongsTo relationshipWithName:@"person"]];
}
@end
