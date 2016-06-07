//
//  SOOrderBuilding.h
//  souban
//
//  Created by JiaHao on 10/29/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseModel.h"


@protocol SOOrderBuildingRoom <NSObject>
@end


@interface SOOrderBuilding : OMBaseModel

@property (strong, nonatomic) NSString<Optional> *buildingName;
@property (strong, nonatomic) NSMutableArray<SOOrderBuildingRoom> *rooms;

@end


@interface SOOrderBuildingRoom : OMBaseModel


@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSString *preferredTime;
@property (strong, nonatomic) NSString *alternativeTime;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSString *priceUnit;
@property (strong, nonatomic) NSNumber *roomId;
@property (strong, nonatomic) NSNumber *areaSize;
@property (strong, nonatomic) NSString<Optional> *fitment;

@end
