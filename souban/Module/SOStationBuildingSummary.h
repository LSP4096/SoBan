//
//  SOStationBuildingSummary.h
//  souban
//
//  Created by 周国勇 on 11/12/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseModel.h"
#import "SOLocation.h"

@protocol SOStationBuildingSummary <NSObject>

@end


@interface SOStationBuildingSummary : OMBaseModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber<Optional> *price;
@property (strong, nonatomic) NSString<Optional> *image;
@property (strong, nonatomic) NSNumber *cubeCount;
@property (strong, nonatomic) SOLocation *location;
@property (strong, nonatomic) NSNumber *inRentCount;

@end
