//
//  OMUser.m
//  OfficeManager
//
//  Created by 周国勇 on 8/20/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMUser.h"
#import "GVUserDefaults+OM.h"
#import "kCommonMacro.h"
#import "NSNotificationCenter+OM.h"


@implementation OMUser

+ (JSONKeyMapper *)keyMapper
{
    JSONKeyMapper *superKeyMapper = [super keyMapper];

    JSONModelKeyMapBlock toModel = ^NSString *(NSString *keyName)
    {
        if ([keyName isEqualToString:@"isPartner"]) return @"partnerStatus";

        return superKeyMapper.JSONToModelKeyBlock(keyName);
    };

    JSONModelKeyMapBlock toJSON = ^NSString *(NSString *keyName)
    {
        if ([keyName isEqualToString:@"partnerStatus"]) return @"isPartner";

        return superKeyMapper.modelToJSONKeyBlock(keyName);
    };

    return [[JSONKeyMapper alloc] initWithJSONToModelBlock:toModel
                                          modelToJSONBlock:toJSON];
}

+ (void)setUser:(OMUser *)aUser
{
    NSString *notificationName = aUser ? kUserLoginSuccess : kUserLogoutSuccess;
    [GVUserDefaults standardUserDefaults].userString = aUser.toJSONString;
    [NSNotificationCenter postNotificationName:notificationName userInfo:nil];
}

+ (instancetype)user
{
    NSError *error = nil;
    OMUser *user = [[OMUser alloc] initWithString:[GVUserDefaults standardUserDefaults].userString error:&error];
    if (error) {
        DDLogError(@"error:%@", error);
        return nil;
    }
    return user;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"partnerStatus"]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}


@end
