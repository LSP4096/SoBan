//
//  UIImage+originImage.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "UIImage+originImage.h"


@implementation UIImage (originImage)

+ (instancetype)originImageWithName:(NSString *)imageName
{
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
