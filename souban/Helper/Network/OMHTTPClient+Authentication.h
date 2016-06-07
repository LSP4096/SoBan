//
//  OMHTTPClient+Authentication.h
//  OfficeManager
//
//  Created by JiaHao on 9/6/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMHTTPClient.h"


@interface OMHTTPClient (Authentication)

- (NSURLSessionDataTask *)requestVertificationCodeByMobile:(NSString *)mobile
                                                completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)loginByMobile:(NSString *)mobile
                               authCode:(NSString *)authCode
                             completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)logoutWithCompletion:(jsonResultBlock)completion;

@end
