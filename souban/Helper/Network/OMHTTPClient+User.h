//
//  OMHTTPClient+User.h
//  souban
//
//  Created by JiaHao on 10/30/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMHTTPClient.h"

@class SOPageModel;


@interface OMHTTPClient (User)


- (NSURLSessionDataTask *)fetchMyOrderListWithPageModel:(SOPageModel *)pageModel
                                             completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchMyCollectionListWithPageModel:(SOPageModel *)pageModel
                                                  completion:(jsonResultBlock)completion;

@end
