//
//  SOPhotoPickerBrowserViewController.h
//  souban
//
//  Created by 周国勇 on 11/11/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "MLPhotoBrowserViewController.h"

@interface SOPhotoPickerBrowserViewController : MLPhotoBrowserViewController

- (instancetype)initWithMedias:(NSArray *)medias;
/**
 *  天传至图片浏览器
 *
 *  @param medias       照片数组
 *  @param currentIndex 当前显示的序号
 *  @param imageView    用于动画效果的imageview
 *
 *  @return instance
 */
+ (instancetype)showWithMedias:(NSArray<NSString *> *)medias currentIndex:(NSInteger)currentIndex fromImageView:(UIImageView *)imageView;

@end
