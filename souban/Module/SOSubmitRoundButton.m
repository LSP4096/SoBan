//
//  SOSubmitRoundButton.m
//  souban
//
//  Created by 周国勇 on 11/11/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOSubmitRoundButton.h"
#import "UIColor+OM.h"


@implementation SOSubmitRoundButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor at_deepSkyBlueColor];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
}

@end
