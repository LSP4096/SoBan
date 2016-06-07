//
//  UIImage+Color.m
//  HBToolkit
//
//  Created by Limboy on 12/25/13.
//  Copyright (c) 2013 Huaban. All rights reserved.
//

#import "UIImage+Color.h"


@implementation UIImage (Color)

+ (UIImage *)imageWithSolidColor:(UIColor *)color size:(CGSize)size
{
    NSParameterAssert(color);
    NSAssert(!CGSizeEqualToSize(size, CGSizeZero), @"Size cannot be CGSizeZero");

    CGRect rect = CGRectMake(0, 0, size.width, size.height);

    // Create a context depending on given size
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);

    // Fill it with your color
    [color setFill];
    UIRectFill(rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [tintColor setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)makeRoundedWithRadius:(float)radius
{
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.width);
    UIGraphicsBeginImageContextWithOptions(self.size, false, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.size.height];
    [path addClip];
    [self drawInRect:rect];
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end
