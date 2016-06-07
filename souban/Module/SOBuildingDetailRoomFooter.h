//
//  SOBuildingDetailRoomFooter.h
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewHeaderFooterView.h"

@class SOBuilding;

@protocol SOBuildingDetailRoomFooterDelegate <NSObject>

- (void)buildingDetailRoomFooterLookMoreTapped;

@end


@interface SOBuildingDetailRoomFooter : OMBaseTableViewHeaderFooterView

+ (CGFloat)height;
- (void)configCellWithText:(NSString *)text;

@property (weak, nonatomic) id<SOBuildingDetailRoomFooterDelegate> delegate;

@end
