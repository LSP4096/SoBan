//
//  SOSurround.h
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseModel.h"

@protocol SOSurround <NSObject>

@end


@interface SOSurround : OMBaseModel

@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *shops;

@end
