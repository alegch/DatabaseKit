//
//  ARSQLiteConnectionTest.m
//  ActiveRecord
//
//  Created by Fjölnir Ásgeirsson on 8.8.2007.
//  Copyright 2007 Fjölnir Ásgeirsson. All rights reserved.
//

#import "ARSQLiteConnectionTest.h"
#import <ActiveRecord/ActiveRecord.h>
#import "GHTestCase+Fixtures.h"

@implementation ARSQLiteConnectionTest
- (void)setUp
{
	[connection release];
	connection = [[super setUpSQLiteFixtures] retain];
}

- (void)tearDown
{
  GHAssertTrue([connection closeConnection], @"Couldn't close connection");
}

- (void)testConnection
{
  GHAssertNotNil(connection, @"connection should not be nil");
}

- (void)testFetchColumns
{
  // Test if we fetch correct columns
  NSArray *columnsFromDb = [connection columnsForTable:@"foo"];
  NSArray *columnsFixture = [NSArray arrayWithObjects:@"id", @"bar", @"baz", @"integer", nil];
  for(NSString *fixture in columnsFixture)
  {
    GHAssertTrue([columnsFromDb containsObject:fixture],
                 @"Columns didn't contain: %@", fixture);
  }
}

- (void)testQuery
{
  NSString *query = @"SELECT * FROM foo" ;
    NSArray *result = [connection executeSQL:query substitutions:nil error:nil];
  GHAssertTrue([result count] == 2, @"foo should have 2 rows");
  NSArray *columns = [[result objectAtIndex:0] allKeys];
  NSArray *expectedColumns = [NSArray arrayWithObjects:@"id", @"bar", @"baz", @"integer", nil];
  for(NSString *fixture in expectedColumns)
  {
    GHAssertTrue([columns containsObject:fixture],
                 @"Columns didn't contain: %@", fixture);
  }
}

- (void)testInMemoryDatabase {
  NSError *err = nil;
  ARSQLiteConnection *inMemoryDb = [ARSQLiteConnection openConnectionToInMemoryDatabase:&err];
  
  GHAssertNil(err, @"An error occured while creating the database (%@)", err);
  
    [inMemoryDb executeSQL:@"CREATE TABLE test(\"id\" INTEGER PRIMARY KEY NOT NULL, \"aString\" varchar(255))" substitutions:nil error:nil];
    [inMemoryDb executeSQL:@"INSERT INTO test(aString) VALUES('foobar')" substitutions:nil error:nil];
    NSArray *fetch = [inMemoryDb executeSQL:@"SELECT * FROM test" substitutions:nil error:nil];
  GHAssertEquals([fetch count], (NSUInteger)1, @"Row count should be 1");
  
  NSDictionary *row = [fetch objectAtIndex:0];
  GHAssertEqualObjects([row objectForKey:@"id"], [NSNumber numberWithInt:1], @"ID should be 1");
  GHAssertEqualObjects([row objectForKey:@"aString"], @"foobar", @"aString should be 'foobar'");
}
@end
