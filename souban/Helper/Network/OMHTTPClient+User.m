//
//  OMHTTPClient+User.m
//  souban
//
//  Created by JiaHao on 10/30/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMHTTPClient+User.h"
#import "SOBuilding.h"
#import "SOCollectBuilding.h"
#import "SOOrderBuildingSummary.h"
#import "SOCollectBuildingSummary.h"
#import "SOPageModel.h"


@implementation OMHTTPClient (User)


- (NSURLSessionDataTask *)fetchMyOrderListWithPageModel:(SOPageModel *)pageModel completion:(jsonResultBlock)completion
{
    NSMutableDictionary *dic = pageModel.toDictionary.mutableCopy;
    return [self getWithRoutePath:@"book" params:dic parseClass:[SOOrderBuildingSummary class] block:completion];
}

- (NSURLSessionDataTask *)fetchMyCollectionListWithPageModel:(SOPageModel *)pageModel completion:(jsonResultBlock)completion
{
    NSMutableDictionary *dic = pageModel.toDictionary.mutableCopy;
    return [self getWithRoutePath:@"collects" params:dic parseClass:[SOCollectBuildingSummary class] block:completion];
}

@end
