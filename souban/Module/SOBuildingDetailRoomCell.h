//
//  SOBuildingDetailRoomCell.h
//  souban
//
//  Created by 周国勇 on 11/2/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewCell.h"

@class SORoom;

//@protocol SOBuildingDetailRoomCellDelegate <NSObject>
//
//- (void)contentTapped:(SOBuildingDetailRoomCell *)sender;
//
//@end


@interface SOBuildingDetailRoomCell : OMBaseTableViewCell

+ (CGFloat)height;
- (void)configCellWithModel:(SORoom *)room;
//@property (nonatomic) id<SOBuildingDetailRoomCellDelegate> delegate;

@end
