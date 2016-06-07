//
//  NSNotificationCenter+OM.m
//  OfficeManager
//
//  Created by 周国勇 on 8/17/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "NSNotificationCenter+OM.h"
#pragma mark - Shopping
NSString *const kShoppingDataChanged = @"kShoppingDataChanged";

#pragma mark - Consigner
NSString *const kPostConsignerSuccess = @"kPostConsignerSuccess";
NSString *const kUpdateConsignerSuccess = @"kPostConsignerSuccess";

#pragma mark - Auth
NSString *const kUserLoginSuccess = @"kUserLoginSuccess";
NSString *const kUserLogoutSuccess = @"kUserLogoutSuccess";
NSString *const kAuthFailed = @"kAuthFailed";

#pragma mark - Order
NSString *const kPaySuccess = @"kPaySuccess";
NSString *const kPayFailed = @"kPayFailed";
NSString *const kOrderSubmitSuccess = @"kOrderSubmitSuccess";

#pragma mark - User
NSString *const kUnreadMessageCountUpdated = @"kUnreadMessageCountUpdated";

NSString *const kCityChanged = @"kCityChanged";

@implementation NSNotificationCenter (OM)

+ (void)registerNotificationWithObserver:(id)observer
                                selector:(SEL)selector
                                    name:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:selector
                                                 name:name
                                               object:nil];
}

+ (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                        object:nil
                                                      userInfo:userInfo];
}

@end
