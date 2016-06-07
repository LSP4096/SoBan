//
//  SOStationBuildingListCell.h
//  souban
//
//  Created by 周国勇 on 11/12/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewCell.h"

@class SOStationBuildingSummary;


@interface SOStationBuildingListCell : OMBaseTableViewCell

- (void)configCellWithModel:(SOStationBuildingSummary *)stationSummary;

@end
