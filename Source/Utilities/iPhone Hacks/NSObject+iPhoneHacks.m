//
//  NSObject+iPhoneHacks.m
//  ActiveRecord
//
//  Created by Fjölnir Ásgeirsson on 27.8.2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#if (TARGET_OS_IPHONE)
#import "NSObject+iPhoneHacks.h"

@implementation NSObject (iPhoneHacks)
+ (NSString *)className
{
	return NSStringFromClass(self);
}
- (NSString *)className
{
	return [[self class] className];
}
@end
#endif