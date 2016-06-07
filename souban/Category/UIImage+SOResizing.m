//
//  UIImage+SOResizing.m
//  souban
//
//  Created by JiaHao on 12/25/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "UIImage+SOResizing.h"


@implementation UIImage (SOResizing)

- (UIImage *)resizedImageWithWidth:(CGFloat)newWidth andStretchAreaFrom:(CGFloat)from1 to:(CGFloat)to1 andFrom:(CGFloat)from2 to:(CGFloat)to2
{
    //    NSAssert(self.size.width < newWidth, @"Cannot scale NewWidth %f > self.size.width %f", newWidth, self.size.width);

    CGFloat originalWidth = self.size.width;
    CGFloat tiledAreaWidth = (newWidth - originalWidth) / 2;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(originalWidth + tiledAreaWidth, self.size.height), NO, self.scale);

    UIImage *firstResizable = [self resizableImageWithCapInsets:UIEdgeInsetsMake(0, from1, 0, originalWidth - to1) resizingMode:UIImageResizingModeStretch];
    [firstResizable drawInRect:CGRectMake(0, 0, originalWidth + tiledAreaWidth, self.size.height)];

    UIImage *leftPart = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, self.size.height), NO, self.scale);

    UIImage *secondResizable = [leftPart resizableImageWithCapInsets:UIEdgeInsetsMake(0, from2 + tiledAreaWidth, 0, originalWidth - to2) resizingMode:UIImageResizingModeStretch];
    [secondResizable drawInRect:CGRectMake(0, 0, newWidth, self.size.height)];

    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return fullImage;
}

@end
