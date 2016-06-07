//
//  SOMyOrderViewCell.h
//  souban
//
//  Created by JiaHao on 10/27/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewCell.h"

@class SOOrderBuildingRoom;


@interface SOMyOrderViewCell : OMBaseTableViewCell

- (void)configWithBuilding:(SOOrderBuildingRoom *)building;


@end
