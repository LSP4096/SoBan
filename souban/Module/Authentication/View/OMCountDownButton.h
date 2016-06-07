//
//  OMCountDownButton.h
//  OfficeManager
//
//  Created by JiaHao on 9/6/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OMCountDownButton : UIButton

- (void)beginCountDownWithSecond:(NSInteger)second;
- (void)stopCountDown;


@end
