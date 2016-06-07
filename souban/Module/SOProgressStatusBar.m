//
//  SOProgressStatusBar.m
//  souban
//
//  Created by JiaHao on 11/19/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOProgressStatusBar.h"


@implementation SOProgressStatusBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)hide
{
    self.hidden = YES;
}
- (void)hideWithAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
    } completion:^(BOOL finished){
    }];
    [UIView animateWithDuration:0.5
        delay:0
        options:UIViewAnimationOptionBeginFromCurrentState
        animations:^(void) {
                         self.alpha = 0;
        }
        completion:^(BOOL completed) {
                        self.hidden = YES;
        }];
}

- (void)showWithLoadingStatus
{
    self.statusLabel.text = @"正在努力加载中...";
    self.alpha = 1;
    self.hidden = NO;
}

- (void)showWithMessage:(NSString *)message
{
    self.statusLabel.text = message;
    self.hidden = NO;
    self.alpha = 1;
}
@end
