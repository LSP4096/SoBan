//
//  SOBuildingDetailTrafficHeader.h
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewHeaderFooterView.h"

@class SOBuilding, SOBuildingStation;


@interface SOBuildingDetailTrafficHeader : OMBaseTableViewHeaderFooterView

+ (CGFloat)heightForBuilding:(SOBuilding *)building;
+ (CGFloat)stationHeightForBuilding:(SOBuildingStation *)building;

- (void)configCellWithBuilding:(SOBuilding *)building;
- (void)configCellWithStation:(SOBuildingStation *)station;

@end
