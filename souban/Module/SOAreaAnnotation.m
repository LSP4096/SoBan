//
//  SOAreaAnnotation.m
//  souban
//
//  Created by JiaHao on 11/19/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOAreaAnnotation.h"


@implementation SOAreaAnnotation

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.layer.borderColor = [UIColor colorWithRed:6 / 255.0 green:130 / 255.0 blue:255 / 255.0 alpha:1].CGColor;
    self.layer.borderWidth = 1;
}

@end
