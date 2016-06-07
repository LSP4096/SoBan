//
//  SOBuildingPOI.h
//  souban
//
//  Created by JiaHao on 11/18/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseModel.h"
#import <CoreLocation/CoreLocation.h>

@protocol SOPOILocation <NSObject>

@end


@interface SOPOILocation : JSONModel

@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

@property (nonatomic) CLLocationCoordinate2D coordinate2d;

@end


@interface SOBuildingPOI : JSONModel

@property (strong, nonatomic) NSNumber *buildingId;
@property (strong, nonatomic) NSString<Optional> *title;
@property (strong, nonatomic) NSNumber *roomCount;
@property (strong, nonatomic) SOPOILocation *location;

@end
