//
//  OMHTTPClient+Authentication.m
//  OfficeManager
//
//  Created by JiaHao on 9/6/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMHTTPClient+Authentication.h"
#import "OMUser.h"


@implementation OMHTTPClient (Authentication)

- (NSURLSessionDataTask *)logoutWithCompletion:(jsonResultBlock)completion
{
    NSURLSessionDataTask *task = [self postWithRoutePath:@"logout" params:nil parseClass:nil block:completion];

    return task;
}

- (NSURLSessionDataTask *)requestVertificationCodeByMobile:(NSString *)mobile
                                                completion:(jsonResultBlock)completion
{
    NSDictionary *parameters = @{ @"phoneNum" : mobile };
    NSURLSessionDataTask *task = [self postWithRoutePath:@"m_code_api" params:parameters parseClass:nil block:completion];
    return task;
}

- (NSURLSessionDataTask *)loginByMobile:(NSString *)mobile
                               authCode:(NSString *)authCode
                             completion:(jsonResultBlock)completion
{
    NSDictionary *parameters = @{ @"phoneNum" : mobile,
                                  @"authCode" : authCode };

    NSURLSessionDataTask *task = [self postWithRoutePath:@"users/auth" params:parameters parseClass:[OMUser class] block:completion];

    return task;
}

@end
