//
//  UIView+Subview.m
//  HBToolkit
//
//  Created by Limboy on 12/26/13.
//  Copyright (c) 2013 Huaban. All rights reserved.
//

#import "UIView+Subview.h"


@implementation UIView (Subview)

- (void)addSubviewWithFadeAnimation:(UIView *)subview
{
    CGFloat finalAlpha = subview.alpha;

    subview.alpha = 0.0;
    [self addSubview:subview];
    [UIView animateWithDuration:0.2 animations:^{
        subview.alpha = finalAlpha;
    }];
}

- (UIView *)iterateSubviewsWithBlock:(BOOL (^)(UIView *view, BOOL *stop))block recursively:(BOOL)recursively
{
    for (UIView *subview in self.subviews) {
        BOOL stop = NO;
        if (block(subview, &stop) && recursively) {
            return [subview iterateSubviewsWithBlock:block recursively:recursively];
        } else if (stop) {
            return subview;
        }
    }
    return nil;
}

- (void)findCellImageViewAndRemoveImage
{
    for (UIView *subView in self.subviews) {
        if (![subView isKindOfClass:[UIImageView class]]) {
            [subView findCellImageViewAndRemoveImage];
        } else {
            // 有针对性的清除些图片
            UIImage *image = ((UIImageView *)subView).image;
            if (image.size.height > 50) {
                ((UIImageView *)subView).image = nil;
            }
        }
    }
}

@end
