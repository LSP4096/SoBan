//
//  UIImage+Resize.m
//  HBToolkit
//
//  Created by Limboy on 12/25/13.
//  Copyright (c) 2013 Huaban. All rights reserved.
//

#import "UIImage+Resize.h"


@implementation UIImage (Resize)

- (void)drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode
{
    CGRect drawRect;
    CGSize size = self.size;

    switch (contentMode) {
        case UIViewContentModeRedraw:
        case UIViewContentModeScaleToFill: {
            // nothing to do
            [self drawInRect:rect];
            return;
        }

        case UIViewContentModeScaleAspectFit: {
            CGFloat factor;

            if (size.width < size.height) {
                factor = rect.size.height / size.height;

            } else {
                factor = rect.size.width / size.width;
            }


            size.width = roundf(size.width * factor);
            size.height = roundf(size.height * factor);

            // otherwise same as center
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect) - size.width / 2.0f),
                                  roundf(CGRectGetMidY(rect) - size.height / 2.0f),
                                  size.width,
                                  size.height);

            break;
        }

        case UIViewContentModeScaleAspectFill: {
            CGFloat factor;

            if (size.width < size.height) {
                factor = rect.size.width / size.width;

            } else {
                factor = rect.size.height / size.height;
            }


            size.width = roundf(size.width * factor);
            size.height = roundf(size.height * factor);

            // otherwise same as center
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect) - size.width / 2.0f),
                                  roundf(CGRectGetMidY(rect) - size.height / 2.0f),
                                  size.width,
                                  size.height);

            break;
        }

        case UIViewContentModeCenter: {
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect) - size.width / 2.0f),
                                  roundf(CGRectGetMidY(rect) - size.height / 2.0f),
                                  size.width,
                                  size.height);
            break;
        }

        case UIViewContentModeTop: {
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect) - size.width / 2.0f),
                                  rect.origin.y - size.height,
                                  size.width,
                                  size.height);
            break;
        }

        case UIViewContentModeBottom: {
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect) - size.width / 2.0f),
                                  rect.origin.y - size.height,
                                  size.width,
                                  size.height);
            break;
        }

        case UIViewContentModeLeft: {
            drawRect = CGRectMake(rect.origin.x,
                                  roundf(CGRectGetMidY(rect) - size.height / 2.0f),
                                  size.width,
                                  size.height);
            break;
        }

        case UIViewContentModeRight: {
            drawRect = CGRectMake(CGRectGetMaxX(rect) - size.width,
                                  roundf(CGRectGetMidY(rect) - size.height / 2.0f),
                                  size.width,
                                  size.height);
            break;
        }

        case UIViewContentModeTopLeft: {
            drawRect = CGRectMake(rect.origin.x,
                                  rect.origin.y,
                                  size.width,
                                  size.height);
            break;
        }

        case UIViewContentModeTopRight: {
            drawRect = CGRectMake(CGRectGetMaxX(rect) - size.width,
                                  rect.origin.y,
                                  size.width,
                                  size.height);
            break;
        }

        case UIViewContentModeBottomLeft: {
            drawRect = CGRectMake(rect.origin.x,
                                  CGRectGetMaxY(rect) - size.height,
                                  size.width,
                                  size.height);
            break;
        }

        case UIViewContentModeBottomRight: {
            drawRect = CGRectMake(CGRectGetMaxX(rect) - size.width,
                                  CGRectGetMaxY(rect) - size.height,
                                  size.width,
                                  size.height);
            break;
        }
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    // clip to rect
    CGContextAddRect(context, rect);
    CGContextClip(context);

    // draw
    [self drawInRect:drawRect];

    CGContextRestoreGState(context);
}

- (UIImage *)healImageOrientation
{
    UIImage *img = self;
    CGImageRef imgRef = img.CGImage;

    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);


    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    bounds.size.width = width;
    bounds.size.height = height;

    CGFloat scaleRatio = bounds.size.width / width;
    CGFloat scaleRatioheight = bounds.size.height / height;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = img.imageOrientation;
    switch (orient) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;

        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;

        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;

        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid?image?orientation"];
            break;
    }
    UIGraphicsBeginImageContext(bounds.size);

    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
    }

    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatioheight);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatioheight);
        CGContextTranslateCTM(context, 0, -height);
    }

    CGContextConcatCTM(context, transform);

    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

@end
