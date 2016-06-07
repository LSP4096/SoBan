//
//  OMHTTPClient+Main.h
//  souban
//
//  Created by 周国勇 on 1/13/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "OMHTTPClient.h"

@interface OMHTTPClient (Main)

- (NSURLSessionDataTask *)fetchLaunchOptionsWithCompletion:(jsonResultBlock)completion;

@end
