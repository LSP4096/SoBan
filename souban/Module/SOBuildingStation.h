//
//  SOBuildingStation.h
//  souban
//
//  Created by 周国勇 on 11/11/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseModel.h"
#import "SOBuilding.h"

@protocol SOBuildingImageDescItem <NSObject>

@end


@interface SOBuildingImageDescItem : JSONModel

@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *name;

@end


@interface SOBuildingStation : OMBaseModel

@property (strong, nonatomic) NSArray<Optional> *images;
@property (strong, nonatomic) NSArray<Optional> *incubatorImages;
@property (strong, nonatomic) NSString *incubatorDescription;

@property (strong, nonatomic) NSNumber *cubeCount;
@property (strong, nonatomic) NSNumber *inRentCount;
@property (strong, nonatomic) NSArray<SOBuildingSummaryItem> *incubatorInfo;
@property (strong, nonatomic) NSArray<SOBuildingImageDescItem> *complements;
@property (strong, nonatomic) NSArray<SOBuildingImageDescItem> *services;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) NSArray<SOTraffic> *traffic;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber<Optional> *price;
@property (strong, nonatomic) NSArray<SOTag, Optional> *tags;
@property (strong, nonatomic) SOLocation *location;

@end
