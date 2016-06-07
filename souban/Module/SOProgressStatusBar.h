//
//  SOProgressStatusBar.h
//  souban
//
//  Created by JiaHao on 11/19/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"


@interface SOProgressStatusBar : UIView <XXNibBridge>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


- (void)hide;
- (void)hideWithAnimation;

- (void)showWithLoadingStatus;

- (void)showWithMessage:(NSString *)message;


@end
