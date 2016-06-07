//
//  UIStoryboard+SO.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "UIStoryboard+SO.h"


@implementation UIStoryboard (SO)

+ (instancetype)main
{
    NSString *name = [NSStringFromSelector(_cmd) stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[NSStringFromSelector(_cmd) substringToIndex:1] uppercaseString]];
    return [UIStoryboard storyboardWithName:name bundle:nil];
}

+ (instancetype)authentication
{
    NSString *name = [NSStringFromSelector(_cmd) stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[NSStringFromSelector(_cmd) substringToIndex:1] uppercaseString]];
    return [UIStoryboard storyboardWithName:name bundle:nil];
}

+ (instancetype)building
{
    NSString *name = [NSStringFromSelector(_cmd) stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[NSStringFromSelector(_cmd) substringToIndex:1] uppercaseString]];
    return [UIStoryboard storyboardWithName:name bundle:nil];
}

+ (instancetype)service
{
    NSString *name = [NSStringFromSelector(_cmd) stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[NSStringFromSelector(_cmd) substringToIndex:1] uppercaseString]];
    return [UIStoryboard storyboardWithName:name bundle:nil];
}

+ (instancetype)user
{
    NSString *name = [NSStringFromSelector(_cmd) stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[NSStringFromSelector(_cmd) substringToIndex:1] uppercaseString]];
    return [UIStoryboard storyboardWithName:name bundle:nil];
}

+ (instancetype)map
{
    NSString *name = [NSStringFromSelector(_cmd) stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[NSStringFromSelector(_cmd) substringToIndex:1] uppercaseString]];
    return [UIStoryboard storyboardWithName:name bundle:nil];
}

+ (instancetype)common
{
    NSString *name = [NSStringFromSelector(_cmd) stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[NSStringFromSelector(_cmd) substringToIndex:1] uppercaseString]];
    return [UIStoryboard storyboardWithName:name bundle:nil];
}

+ (instancetype)explore
{
    NSString *name = [NSStringFromSelector(_cmd) stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[NSStringFromSelector(_cmd) substringToIndex:1] uppercaseString]];
    return [UIStoryboard storyboardWithName:name bundle:nil];
}
@end
