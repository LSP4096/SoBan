//
//  SOSendBuildingRequestModel.h
//  souban
//
//  Created by JiaHao on 10/30/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseModel.h"


@interface SOSendBuildingRequestModel : OMBaseModel


@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *areaId;
@property (strong, nonatomic) NSNumber *areaSize;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *block;

@end
