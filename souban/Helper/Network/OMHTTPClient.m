
//  BTHTTPClient.m
//  BailkalTravel
//
//  Created by 周国勇 on 10/8/14.
//  Copyright (c) 2014 whalefin. All rights reserved.
//

#import "OMHTTPClient.h"
#import "JSONCategory.h"
#import <JSONModel.h>
#import "NSNotificationCenter+OM.h"
#import "OMResponse.h"
#import "OMUser.h"
#import "kCommonMacro.h"
//#import <BugHD/BugHD.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "SOCity.h"

typedef void (^afSuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^afFailBlock)(NSURLSessionDataTask *task, NSError *error);


@implementation OMHTTPClient

+ (OMHTTPClient *)sharedClient
{
    OMHTTPClient *_sharedClient = nil;

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    _sharedClient = [[OMHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:mockUrl] sessionConfiguration:config];
    _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", @"text/json", @"text/javascript", nil];

    return _sharedClient;
}

+ (OMHTTPClient *)realClient
{
    OMHTTPClient *_sharedClient = nil;

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;

    _sharedClient = [[OMHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:rootUrl] sessionConfiguration:config];
    _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", @"text/json", @"text/javascript", nil];

    return _sharedClient;
}

- (NSURLSessionDataTask *)getWithRoutePath:(NSString *)path
                                    params:(NSDictionary *)params
                                parseClass:(Class)modelClass
                                     block:(jsonResultBlock)resultblock
{
    return [self sessionDataTaskWithRoutePath:path httpMethod:@"get" params:params parseClass:modelClass block:resultblock];
}

- (NSURLSessionDataTask *)postWithRoutePath:(NSString *)path
                                     params:(NSDictionary *)params
                                 parseClass:(Class)modelClass
                                      block:(jsonResultBlock)resultblock
{
    return [self sessionDataTaskWithRoutePath:path httpMethod:@"post" params:params parseClass:modelClass block:resultblock];
}

- (NSURLSessionDataTask *)putWithRoutePath:(NSString *)path
                                    params:(NSDictionary *)params
                                parseClass:(Class)modelClass
                                     block:(jsonResultBlock)resultblock
{
    return [self sessionDataTaskWithRoutePath:path httpMethod:@"put" params:params parseClass:modelClass block:resultblock];
}

- (NSURLSessionDataTask *)deleteWithRoutePath:(NSString *)path
                                       params:(NSDictionary *)params
                                   parseClass:(Class)modelClass
                                        block:(jsonResultBlock)resultblock
{
    return [self sessionDataTaskWithRoutePath:path httpMethod:@"delete" params:params parseClass:modelClass block:resultblock];
}

- (NSURLSessionDataTask *)sessionDataTaskWithRoutePath:(NSString *)path
                                            httpMethod:(NSString *)httpMethod
                                                params:(NSDictionary *)params
                                            parseClass:(Class)modelClass
                                                 block:(jsonResultBlock)resultblock
{
    NSParameterAssert(httpMethod);
    NSParameterAssert(path);

    void (^sendErrorBlock)(NSError *error) = ^void(NSError *error) {
        CLS_LOG(@"error_json, path:%@, params:%@, info:%@", path, [self commonParasToDic:params].description, error.debugDescription);
    };

    void (^parseArrayBlock)(NSArray *dictionaryArray, jsonResultBlock resultBlock) = ^void(NSArray *dictionaryArray, jsonResultBlock resultBlock) {

        NSMutableArray *array = [NSMutableArray new];
        if (modelClass) {
            __block NSError *error = nil;
            [dictionaryArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 id model = [[modelClass alloc] initWithDictionary:obj error:&error];
                 if (model) {
                     [array addObject:model];
                 } else if (error) {
                     *stop = YES;
                 }
             }];
            if (resultBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        sendErrorBlock(error);
                        error = [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier code:kJSONConvertError userInfo:error.userInfo];
                        resultblock(nil, error);
                    } else {
                        resultblock(array, nil);
                    }
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (resultblock) {
                    resultblock(dictionaryArray, nil);
                }
            });
        }
    };

    void (^parseDicBlock)(NSDictionary *dic, jsonResultBlock resultBlock) = ^void(NSDictionary *dic, jsonResultBlock resultBlock) {
        NSError *error = nil;
        
        if (modelClass) {
            id model = [[modelClass alloc] initWithDictionary:dic error:&error];
            if (model) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (resultblock) {
                        resultblock(model, nil);
                    }
                });
            } else if (error) {
                sendErrorBlock(error);
                error = [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier code:kJSONConvertError userInfo:error.userInfo];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (resultblock) {
                        resultblock(nil, error);
                    }
                });
            }
        } else {
            resultblock(dic, nil);
        }
    };
    
    
    afSuccessBlock successBlock = ^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
        
        if (urlResponse.statusCode != 200) {
            CLS_LOG(@"request_failed, path:%@, params:%@, code:%ld, info:%@", path, [self commonParasToDic:params], (long)urlResponse.statusCode, urlResponse.allHeaderFields.description);

            if (resultblock) {
                NSError *error = [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier code:500 userInfo:@{@"errorMsg":@"解析错误"}];
                resultblock(nil, error);
            }
            return ;
        }
        
        NSError    *error    = nil;
        OMResponse *response = [[OMResponse alloc] initWithDictionary:responseObject error:&error];
        if (error) {
            sendErrorBlock(error);
            error = [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier code:kJSONConvertError userInfo:error.userInfo];
            if (resultblock) {
                resultblock(nil, error);
            }
            return;
        }

        if (response.data) {
            id data = response.data;
            // 是否是array
            if ([data isKindOfClass:[NSArray class]]) {
                parseArrayBlock(data, resultblock);
            } else if ([data isKindOfClass:[NSDictionary class]]) {
                parseDicBlock(data, resultblock);
            } else {
                parseDicBlock(data, nil);
            }
        } else {
            if (response.status != kServerCodeSuccess) {
                NSError *error = [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier code:response.status userInfo:@{@"errorMsg":response.errMsg}];
                if (response.status == kServerCodeAuthFailed || response.status == kServerCodeUnLogin) {
                    [OMUser setUser:nil];
                    [NSNotificationCenter postNotificationName:kAuthFailed userInfo:nil];
                }
                if (resultblock) {
                    resultblock(nil, error);
                }
                return;
            } else {
                resultblock(response, nil);
            }
        }
    };
    
    
    afFailBlock failBlock = ^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
        if (error.code == kCFURLErrorTimedOut) {
            
        } else if (urlResponse && urlResponse.statusCode != 200) {
            CLS_LOG(@"request_failed, path:%@, params:%@, code:%ld, info:%@", path, [self commonParasToDic:params], (long)urlResponse.statusCode, urlResponse.allHeaderFields.description);
        }
        if (resultblock) {
            resultblock(nil, error);
        }
    };

    params = [self commonParasToDic:params];

    // 在mock环境下URL中有小于两位数的id存在会出错，这里先处理一下
    if ([self.baseURL.absoluteString isEqualToString:mockUrl]) {
        NSArray *paths = [path componentsSeparatedByString:@"/"];
        NSMutableArray *tempPaths = paths.mutableCopy;
        for (NSString *temp in paths) {
            if ([self isPureInt:temp] && temp.integerValue < 10) {
                [tempPaths replaceObjectAtIndex:[paths indexOfObject:temp] withObject:@100];
            }
        }
        path = [tempPaths componentsJoinedByString:@"/"];
    }

    if ([httpMethod isEqualToString:@"get"]) {
        return [self GET:path parameters:params progress:nil success:successBlock failure:failBlock];
    } else if ([httpMethod isEqualToString:@"put"]) {
        return [self PUT:path parameters:params success:successBlock failure:failBlock];
    } else if ([httpMethod isEqualToString:@"delete"]) {
        return [self DELETE:path parameters:params success:successBlock failure:failBlock];
    } else if ([httpMethod isEqualToString:@"post"]) {
        return [self POST:path parameters:params progress:nil success:successBlock failure:failBlock];
    } else {
        return nil;
    }
}

- (BOOL)isPureInt:(NSString *)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (NSDictionary *)commonParasToDic:(NSDictionary *)params {
    if ([OMUser user]) {
        NSMutableDictionary *dic = params ? params.mutableCopy : @{}.mutableCopy;
        dic[@"userId"] = @([OMUser user].uniqueId.integerValue);
        dic[@"token"] = [OMUser user].token;
        params = [NSDictionary dictionaryWithDictionary:dic];
    }
    
    NSMutableDictionary *dic = params ? params.mutableCopy : @{}.mutableCopy;
    dic[@"cityId"] = [SOCity currentCityId]?[SOCity currentCityId]:@(87);
    params = [NSDictionary dictionaryWithDictionary:dic];
    return params;
}

- (void)setVersion:(NSString *)version {
    NSString *type = [NSString stringWithFormat:@"application/vnd.souban-v%@+json", version];
    [self.requestSerializer setValue:type forHTTPHeaderField:@"Accept"];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:type, nil];

}
@end
