//
//  SOBuildingStationListHeaderView.m
//  souban
//
//  Created by 周国勇 on 11/18/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingStationListHeaderView.h"
#import "UIView+Layout.h"


@interface SOBuildingStationListHeaderView ()

@end


@implementation SOBuildingStationListHeaderView

- (CGFloat)height
{
    [self.contentLabel sizeToFit];
    return self.contentLabel.height + 20 + 52;
}

@end
