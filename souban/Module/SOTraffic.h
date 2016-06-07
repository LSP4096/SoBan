//
//  SOTraffic.h
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseModel.h"

@protocol SOTraffic <NSObject>

@end


@interface SOTraffic : OMBaseModel

@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *trafficDescription;
@property (strong, nonatomic) NSString *name;

@end
