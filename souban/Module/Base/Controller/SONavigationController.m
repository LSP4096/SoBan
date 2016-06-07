//
//  SONavigationController.m
//  souban
//
//  Created by 周国勇 on 10/27/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SONavigationController.h"


@implementation SONavigationController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return self.topViewController.preferredStatusBarUpdateAnimation;
}
@end
