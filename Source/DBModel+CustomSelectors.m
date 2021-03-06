//
//  DBModel+CustomSelectors.m
//  DatabaseKit
//
//  Created by Fjölnir Ásgeirsson on 12.8.2007.
//  Copyright 2007 Fjölnir Ásgeirsson. All rights reserved.
//

#import "DBModel.h"
#import "DBModelPrivate.h"
#import <objc/runtime.h>

@implementation DBModel (CustomSelectors)
- (BOOL)respondsToSelector:(SEL)aSelector
{
    NSString *attributeName;
    [DBModel typeOfSelector:aSelector attributeName:&attributeName];
    if(attributeName && [self relationshipForKey:attributeName])
        return YES;
    return [super respondsToSelector:aSelector];
}

+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
    NSString *attributeName;
    BOOL isReturn = NO;
    switch((int)[DBModel typeOfSelector:aSEL attributeName:&attributeName]) {
        case DBAttributeSelectorReader: {
                class_addMethod(self, aSEL, imp_implementationWithBlock(^(DBModel *self){
                    return [self valueForKey:attributeName];
                }), "@@:");
                isReturn = YES;
            }
        break;
        case DBAttributeSelectorWriter: {
                class_addMethod(self, aSEL, imp_implementationWithBlock(^(DBModel *self, id value) {
                    [self setValue:value forKey:attributeName];
                }), "v@:@");
                isReturn = YES;
            }
        break;
        case DBAttributeSelectorAdder: {
                class_addMethod(self, aSEL, imp_implementationWithBlock(^(DBModel *self, id value) {
                    [self addRecord:value forKey:attributeName];
                }), "v@:@");
                isReturn = YES;
        }
        break;
        case DBAttributeSelectorRemover: {
                class_addMethod(self, aSEL, imp_implementationWithBlock(^(DBModel *self, id value) {
                    [self removeRecord:value forKey:attributeName];
                }), "v@:@");
                isReturn = YES;
        }
        break;
    }
    
    if (isReturn) {
        return YES;
    }
    
    return [super resolveInstanceMethod:aSEL];
}
@end
