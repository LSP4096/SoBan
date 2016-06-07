//
//  SOBuildingDetailSurroundCell.h
//  souban
//
//  Created by 周国勇 on 11/2/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewCell.h"

@class SOSurround;


@interface SOBuildingDetailSurroundCell : OMBaseTableViewCell

+ (CGFloat)height;
- (void)configCellWithModel:(SOSurround *)surround;

@end
