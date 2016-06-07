//
//  SOBuildingDetailDescriptionHeader.h
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewHeaderFooterView.h"

/**
 *  显示照片以及价格低至等信息的Header
 */
@class SOBuilding, SOBuildingStation;


@interface SOBuildingDetailDescriptionHeader : OMBaseTableViewHeaderFooterView

+ (CGFloat)height;
- (void)configCellWithModel:(SOBuilding *)building;
- (void)configCellWithStationModel:(SOBuildingStation *)building;

@end
