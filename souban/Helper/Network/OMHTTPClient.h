//
//  BTHTTPClient.h
//  BailkalTravel
//
//  Created by 周国勇 on 10/8/14.
//  Copyright (c) 2014 whalefin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "NSError+ErrorMessage.h"

//#define rootUrl @"http://121.43.115.184/officeManager"

#ifdef DEBUG
#define rootUrl @"http://api-test.91souban.com/"
#else
#define rootUrl @"http://api.91souban.com/"
#endif

#define mockUrl @"http://rap.91souban.com/mockjsdata/1/"

//#define API_VERSION @"v1"
typedef void (^jsonResultBlock)(id resultObject, NSError *error);

static NSInteger const kServerCodeSuccess = 1;
static NSInteger const kServerCodeAuthFailed = 106;
static NSInteger const kServerCodeUnLogin = 108;
static NSInteger const kJSONConvertError = 10101;


@interface OMHTTPClient : AFHTTPSessionManager

+ (OMHTTPClient *)sharedClient;

+ (OMHTTPClient *)realClient;

- (NSURLSessionDataTask *)getWithRoutePath:(NSString *)path
                                    params:(NSDictionary *)params
                                parseClass:(Class)modelClass
                                     block:(jsonResultBlock)resultblock;

- (NSURLSessionDataTask *)postWithRoutePath:(NSString *)path
                                     params:(NSDictionary *)params
                                 parseClass:(Class)modelClass
                                      block:(jsonResultBlock)resultblock;

- (NSURLSessionDataTask *)putWithRoutePath:(NSString *)path
                                    params:(NSDictionary *)params
                                parseClass:(Class)modelClass
                                     block:(jsonResultBlock)resultblock;

- (NSURLSessionDataTask *)deleteWithRoutePath:(NSString *)path
                                       params:(NSDictionary *)params
                                   parseClass:(Class)modelClass
                                        block:(jsonResultBlock)resultblock;

- (NSURLSessionDataTask *)sessionDataTaskWithRoutePath:(NSString *)path
                                            httpMethod:(NSString *)httpMethod
                                                params:(NSDictionary *)params
                                            parseClass:(Class)modelClass
                                                 block:(jsonResultBlock)resultblock;

- (void)setVersion:(NSString *)version;
@end
