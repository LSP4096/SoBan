//
//  SOMedia+URL.h
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOMedia.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SOMedia (URL)
- (NSURL *)originURL;
- (NSURL *)webpURL;
- (NSURL *)webpURLWithWidth:(CGFloat)width;
- (NSURL *)thumbURL;
@end
