//
//  UIImage+Resize.h
//  HBToolkit
//
//  Created by Limboy on 12/25/13.
//  Copyright (c) 2013 Huaban. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (Resize)

- (void)drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode;
- (UIImage *)healImageOrientation;
@end
