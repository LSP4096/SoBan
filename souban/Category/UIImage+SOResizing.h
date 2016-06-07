//
//  UIImage+SOResizing.h
//  souban
//
//  Created by JiaHao on 12/25/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (SOResizing)

- (UIImage *)resizedImageWithWidth:(CGFloat)newWidth andStretchAreaFrom:(CGFloat)from1 to:(CGFloat)to1 andFrom:(CGFloat)from2 to:(CGFloat)to2;


@end
