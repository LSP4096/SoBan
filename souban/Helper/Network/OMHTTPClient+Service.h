//
//  OMHTTPClient+Service.h
//  souban
//
//  Created by JiaHao on 10/30/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMHTTPClient.h"
#import "SOLoadRequestModel.h"


@class SOSendBuildingRequestModel, SOFindBuildingRequestModel, SOFinancialInstallmentRequestModel, SOFinancialManageRequestModel, SOFinancialMortgageRequestModel;


@interface OMHTTPClient (Service)


- (NSURLSessionDataTask *)sendBuildingWithRequestModel:(SOSendBuildingRequestModel *)model
                                            completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)findBuildingWithRequestModel:(SOFindBuildingRequestModel *)model
                                            completion:(jsonResultBlock)completion;


- (NSURLSessionDataTask *)loanWithRequestModel:(SOLoadRequestModel *)model
                                    completion:(jsonResultBlock)completion;


// POST
- (NSURLSessionDataTask *)MortgageWithRequestModel:(SOFinancialMortgageRequestModel *)model
                                        completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)installmentWithRequestModel:(SOFinancialInstallmentRequestModel *)model
                                           completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)manageWithRequestModel:(SOFinancialManageRequestModel *)model
                                      completion:(jsonResultBlock)completion;


// GET
- (NSURLSessionDataTask *)fetchAreasListWithCompletion:(jsonResultBlock)completion;
- (NSURLSessionDataTask *)fetchProviceListWithCompletion:(jsonResultBlock)completion;


@end
