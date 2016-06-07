//
//  UIImage+Color.h
//  HBToolkit
//
//  Created by Limboy on 12/25/13.
//  Copyright (c) 2013 Huaban. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (Color)

+ (UIImage *)imageWithSolidColor:(UIColor *)color size:(CGSize)size;
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)makeRoundedWithRadius:(float)radius;
@end
