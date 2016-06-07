//
//  OMHTTPClient+Explore.m
//  souban
//
//  Created by 周国勇 on 12/23/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMHTTPClient+Explore.h"
#import "SOBanner.h"
#import "SOGift.h"

@implementation OMHTTPClient (Explore)

- (NSURLSessionDataTask *)fetchGiftsWithCompletion:(jsonResultBlock)completion
{
    return [self getWithRoutePath:@"explore/gifts" params:@{@"pageIndex":@(0), @"pageSize":@(1000)} parseClass:[SOGift class] block:completion];
}

- (NSURLSessionDataTask *)fetchExploreBannersWithCompletion:(jsonResultBlock)completion
{
    return [self getWithRoutePath:@"explore/banners" params:nil parseClass:[SOBanner class] block:completion];
}

- (NSURLSessionDataTask *)fetchFilingsWithUserId:(NSNumber *)userId page:(SOPageModel *)page type:(SOFilingStep)type completion:(jsonResultBlock)completion
{
    NSParameterAssert(userId);
    NSMutableDictionary *dic = page.toDictionary.mutableCopy;
    dic[@"type"] = @(type);

    return [self getWithRoutePath:[NSString stringWithFormat:@"partners/%@/filings", userId] params:dic parseClass:[SOFiling class] block:completion];
}

- (NSURLSessionDataTask *)fetchFilingDetailWithUserId:(NSNumber *)userId filingId:(NSNumber *)filingId completion:(jsonResultBlock)completion
{
    NSParameterAssert(userId);
    return [self getWithRoutePath:[NSString stringWithFormat:@"partners/%@/filings/%@", userId, filingId] params:nil parseClass:[SOFilingDetail class] block:completion];
}

- (NSURLSessionDataTask *)postFilings:(SOFiling *)filings withUserId:(NSNumber *)userId completion:(jsonResultBlock)completion
{
    return [self postWithRoutePath:[NSString stringWithFormat:@"partners/%@/filings", userId] params:filings.toDictionary parseClass:nil block:completion];
}

- (NSURLSessionDataTask *)editFilings:(SOFiling *)filings withUserId:(NSNumber *)userId completion:(jsonResultBlock)completion
{
    return [self putWithRoutePath:[NSString stringWithFormat:@"partners/%@/filings/%@", userId, filings.uniqueId] params:filings.toDictionary parseClass:nil block:completion];
}

- (NSURLSessionDataTask *)applyPartnersWithName:(NSString *)name bankName:(NSString *)bankName cardNumber:(NSString *)cardNumber completion:(jsonResultBlock)completion
{
    NSParameterAssert(name);
    NSParameterAssert(bankName);
    NSParameterAssert(cardNumber);

    return [self postWithRoutePath:@"/partners/apply" params:@{ @"bankCardNumber" : cardNumber,
                                                                @"bankName" : bankName,
                                                                @"name" : name }
                        parseClass:nil
                             block:completion];
}
@end
