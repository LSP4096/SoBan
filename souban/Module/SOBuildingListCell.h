//
//  SOBuildingListCell.h
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewCell.h"

@class SOBuildingSummary;


@interface SOBuildingListCell : OMBaseTableViewCell

- (void)configCellWithModel:(SOBuildingSummary *)buildingSummary;

@end
