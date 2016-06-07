//
//  UIButton+Block.h
//  OfficeManager
//
//  Created by JiaHao on 9/23/15.
//  Copyright © 2015 whalefin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ActionBlock)(NSInteger tag);


@interface UIButton (Block)
- (void)addActionHandler:(ActionBlock)touchHandler;
@end
