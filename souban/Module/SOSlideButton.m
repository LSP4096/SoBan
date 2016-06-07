//
//  SOSlideButton.m
//  souban
//
//  Created by Rawlings on 15/12/28.
//  Copyright © 2015年 wajiang. All rights reserved.
//

#import "SOSlideButton.h"
#import "UIColor+ATColors.h"
#import "UIView+Layout.h"


@implementation SOSlideButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor at_deepSkyBlueColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {}

@end
