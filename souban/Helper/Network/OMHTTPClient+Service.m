//
//  OMHTTPClient+Service.m
//  souban
//
//  Created by JiaHao on 10/30/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMHTTPClient+Service.h"
#import "SOSendBuildingRequestModel.h"
#import "SOFindBuildingRequestModel.h"
#import "OMUser.h"
#import "SOFinancialInstallmentRequestModel.h"
#import "SOFinancialAreasModel.h"
#import "SOFinancialMortgageRequestModel.h"
#import "SOFinancialManageRequestModel.h"
#import "SOFinancialProviceModel.h"


@implementation OMHTTPClient (Service)


- (NSURLSessionDataTask *)sendBuildingWithRequestModel:(SOSendBuildingRequestModel *)model
                                            completion:(jsonResultBlock)completion
{
    NSMutableDictionary *dic = model.toDictionary.mutableCopy ? model.toDictionary.mutableCopy : @{}.mutableCopy;
    return [self postWithRoutePath:@"roomRent" params:dic parseClass:nil block:completion];
}

- (NSURLSessionDataTask *)findBuildingWithRequestModel:(SOFindBuildingRequestModel *)model
                                            completion:(jsonResultBlock)completion
{
    NSMutableDictionary *dic = model.toDictionary.mutableCopy ? model.toDictionary.mutableCopy : @{}.mutableCopy;
    return [self postWithRoutePath:@"roomRequest" params:dic parseClass:nil block:completion];
}

- (NSURLSessionDataTask *)loanWithRequestModel:(SOLoadRequestModel *)model
                                    completion:(jsonResultBlock)completion
{
    NSMutableDictionary *dic = model.toDictionary.mutableCopy;
    return [self postWithRoutePath:[NSString stringWithFormat:@"mortgage/%@", [OMUser user].uniqueId] params:dic parseClass:nil block:completion];
}




- (NSURLSessionDataTask *)MortgageWithRequestModel:(SOFinancialMortgageRequestModel *)model
                                           completion:(jsonResultBlock)completion
{
    NSMutableDictionary *dic = model.toDictionary.mutableCopy;
    return [self postWithRoutePath:@"addPropertyMortgageLoan" params:dic parseClass:nil block:completion];
}

- (NSURLSessionDataTask *)installmentWithRequestModel:(SOFinancialInstallmentRequestModel *)model
                                           completion:(jsonResultBlock)completion
{
    NSMutableDictionary *dic = model.toDictionary.mutableCopy;
    return [self postWithRoutePath:@"addOwnerMortgageLoan" params:dic parseClass:nil block:completion];
}

- (NSURLSessionDataTask *)manageWithRequestModel:(SOFinancialManageRequestModel *)model
                                           completion:(jsonResultBlock)completion
{
    NSMutableDictionary *dic = model.toDictionary.mutableCopy;
    return [self postWithRoutePath:@"addBusinessSupportLoan" params:dic parseClass:nil block:completion];
}




- (NSURLSessionDataTask *)fetchAreasListWithCompletion:(jsonResultBlock)completion{
    return [self getWithRoutePath:@"getAreaList" params:@{@"cityCode" : @330100 } parseClass:[SOFinancialAreasModel class] block:completion];
}

- (NSURLSessionDataTask *)fetchProviceListWithCompletion:(jsonResultBlock)completion{
    return [self getWithRoutePath:@"queryProviceData" params:nil parseClass:[SOFinancialProviceModel class] block:completion];
}

@end
