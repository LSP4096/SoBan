//
//  OMCountDownButton.m
//  OfficeManager
//
//  Created by JiaHao on 9/6/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMCountDownButton.h"


@interface OMCountDownButton ()

@property (strong, nonatomic) NSTimer *countTimer;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSString *originTitle;
@property (strong, nonatomic) UIColor *originTitleColor;
@property (strong, nonatomic) UIFont *originFont;

@end


@implementation OMCountDownButton

- (void)beginCountDownWithSecond:(NSInteger)second
{
    self.originTitleColor = self.currentTitleColor;
    self.originTitle = self.currentTitle;
    self.count = second;
    self.originFont = self.titleLabel.font;
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changecurrentTitleString) userInfo:nil repeats:YES];
    NSString *countString = [NSString stringWithFormat:@"%li秒后重新发送", (long)self.count];
    [self setTitle:countString forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
    self.userInteractionEnabled = NO;
}

- (void)changecurrentTitleString
{
    NSString *countString = [NSString stringWithFormat:@"%li秒后重新发送", (long)self.count - 1];
    [self setTitle:countString forState:UIControlStateNormal];
    if (self.count-- <= 1.0) {
        [self stopCountDown];
    }
}


- (void)stopCountDown
{
    [self.countTimer invalidate];
    self.countTimer = nil;
    self.count = 60;
    [self.titleLabel setFont:self.originFont];
    [self setTitle:self.originTitle forState:UIControlStateNormal];
    [self setTitleColor:self.originTitleColor forState:UIControlStateNormal];

    self.userInteractionEnabled = YES;
}

- (void)dealloc
{
    [self stopCountDown];
}


@end
