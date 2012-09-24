#import "ARRelationshipColumn.h"
#import "ARBasePrivate.h"
#import "ARTable.h"
#import "ARQuery.h"

@implementation ARRelationshipColumn
#pragma mark Key parser
#pragma mark -
- (BOOL)respondsToKey:(NSString *)key supportsAdding:(BOOL *)supportsAddingRet
{
    if(supportsAddingRet != NULL)
        *supportsAddingRet = NO;
    if([[self.record columns] containsObject:key])
        return YES;
    return NO;
}
#pragma mark -
- (id)retrieveRecordForKey:(NSString *)key
{
    if(![self respondsToKey:key])
        return nil;
    ARQuery *query = [[self.record.table select:key] where:@{ @"id": @(self.record.databaseId) }];
    if([query count] < 1)
    {
        ARDebugLog(@"Couldn't get result: %@", query);
        return nil;
    }
    return query[0][key];
}
- (id)retrieveRecordForKey:(NSString *)key
                    filter:(NSString *)whereSQL
                     order:(NSString *)orderSQL
                     limit:(NSUInteger)limit
{
	return [self retrieveRecordForKey:key];
}
- (void)sendRecord:(id)aRecord forKey:(NSString *)key
{
    if(![self respondsToKey:key])
        return;
    [[[self.record.table update:@{ key: aRecord }] where:@{ @"id": @(self.record.databaseId) }] execute];
}

@end
