//
//  SOCollectBuilding.h
//  souban
//
//  Created by JiaHao on 10/29/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseModel.h"

@protocol SOCollectBuildingRoom <NSObject>
@end


@interface SOCollectBuilding : OMBaseModel

@property (strong, nonatomic) NSString<Optional> *buildingName;
@property (strong, nonatomic) NSMutableArray<SOCollectBuildingRoom> *rooms;

@end


@interface SOCollectBuildingRoom : OMBaseModel

@property (strong, nonatomic) NSNumber *roomId;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSString *priceUnit;
@property (strong, nonatomic) NSNumber *areaSize;
@property (strong, nonatomic) NSString<Optional> *fitment;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray<Optional> *tags;
//@property (nonatomic) BOOL collected;

@end
