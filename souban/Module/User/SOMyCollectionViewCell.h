//
//  SOMyCollectionViewCell.h
//  souban
//
//  Created by JiaHao on 10/27/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewCell.h"
#import "SOCollectBuildingSummary.h"

@class SOCollectBuildingRoom;
@protocol SOMyCollectionViewControllerDelegate <NSObject>

- (void)uncollectBuilding:(SOCollectBuildingRoom *)room Building:(SOCollectBuilding *)buiding;

@end


@interface SOMyCollectionViewCell : OMBaseTableViewCell

- (void)configWithBuilding:(SOCollectBuildingRoom *)room Building:(SOCollectBuilding *)building;

@property (weak, nonatomic) id<SOMyCollectionViewControllerDelegate> delegate;

@end
