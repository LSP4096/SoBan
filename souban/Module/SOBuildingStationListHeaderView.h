//
//  SOBuildingStationListHeaderView.h
//  souban
//
//  Created by 周国勇 on 11/18/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SOBuildingStationListHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (CGFloat)height;

@end
