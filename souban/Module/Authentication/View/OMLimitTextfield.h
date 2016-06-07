//
//  OMLimitTextfield.h
//  OfficeManager
//
//  Created by JiaHao on 9/6/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OMLimitTextfield : UITextField

@property (assign, nonatomic) CGFloat indent;
@property (strong, nonatomic) UIImage *rightViewImage;
@property (assign, nonatomic) BOOL isCorrectText;

@end
