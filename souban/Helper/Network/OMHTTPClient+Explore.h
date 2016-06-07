//
//  OMHTTPClient+Explore.h
//  souban
//
//  Created by 周国勇 on 12/23/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMHTTPClient.h"
#import "SOPageModel.h"
#import "SOFiling.h"
#import "SOFilingDetail.h"


@interface OMHTTPClient (Explore)

- (NSURLSessionDataTask *)fetchGiftsWithCompletion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchExploreBannersWithCompletion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchFilingsWithUserId:(NSNumber *)userId page:(SOPageModel *)page type:(SOFilingStep)type completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchFilingDetailWithUserId:(NSNumber *)userId filingId:(NSNumber *)filingId completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)postFilings:(SOFiling *)filings withUserId:(NSNumber *)userId completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)editFilings:(SOFiling *)filings withUserId:(NSNumber *)userId completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)applyPartnersWithName:(NSString *)name bankName:(NSString *)bankName cardNumber:(NSString *)cardNumber completion:(jsonResultBlock)completion;

@end
