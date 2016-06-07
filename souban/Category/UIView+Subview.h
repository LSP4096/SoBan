//
//  UIView+Subview.h
//  HBToolkit
//
//  Created by Limboy on 12/26/13.
//  Copyright (c) 2013 Huaban. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (Subview)

- (void)addSubviewWithFadeAnimation:(UIView *)subview;

- (UIView *)iterateSubviewsWithBlock:(BOOL (^)(UIView *view, BOOL *stop))block recursively:(BOOL)recursively;

- (void)findCellImageViewAndRemoveImage;

@end
