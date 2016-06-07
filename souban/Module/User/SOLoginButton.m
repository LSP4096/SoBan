//
//  SOLoginButton.m
//  souban
//
//  Created by JiaHao on 11/16/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOLoginButton.h"


@implementation SOLoginButton


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitle:@"点击登录" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        self.layer.borderWidth = 1.0f;
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.backgroundColor = [UIColor colorWithRed:6.0f / 255.0f green:130.0f / 255.0f blue:255.0f / 255.0f alpha:0.5f];
    }
    return self;
}

@end
