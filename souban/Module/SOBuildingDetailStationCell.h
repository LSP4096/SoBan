//
//  SOBuildingDetailStationCell.h
//  souban
//
//  Created by 周国勇 on 11/11/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewCell.h"

@class SOBuildingStation;


@interface SOBuildingDetailStationCell : OMBaseTableViewCell

+ (CGFloat)height;
- (void)configCellWithModel:(SOBuildingStation *)station;

@end
