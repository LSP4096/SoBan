//
//  SOCommonSlideView.h
//  souban
//
//  Created by 周国勇 on 12/28/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOSlideButton.h"
@class SOCommonSlideView;

@protocol SOCommonSlideViewDelegate <NSObject>
@optional
- (void)slideView:(SOCommonSlideView *)slideView didSelectedTagWithIndex:(NSInteger)index button:(SOSlideButton *)button;
@end


@interface SOCommonSlideView : UIView
@property (nonatomic, weak) id<SOCommonSlideViewDelegate> delegate;

/// 老接口
+ (instancetype)slideViewWithTagsArray:(NSArray<NSString *> *)tagsArray;
- (instancetype)initWithTagsArray:(NSArray<NSString *> *)tagsArray;


/**
 *  创建标签选择器视图
 *
 *  @param tagsArray        [标签按钮的文字]数组
 *  @param separatorShowed  是否显示分隔线
 *  @param bottomViewShowed 是否显示底部指示条
 *
 *  @return SlideView 高度/字体 待定
 */
+ (instancetype)slideViewWithTagsArray:(NSArray<NSString *> *)tagsArray
                       separatorShowed:(BOOL)separatorShowed
                      bottomViewShowed:(BOOL)bottomViewShowed;
/**
 *  创建标签选择器视图
 *
 *  @param tagsArray        [标签按钮的文字]数组
 *  @param separatorShowed  是否显示分隔线
 *  @param bottomViewShowed 是否显示底部指示条
 *
 *  @return SlideView 高度/字体 待定
 */
- (instancetype)initWithTagsArray:(NSArray<NSString *> *)tagsArray
                  separatorShowed:(BOOL)separatorShowed
                 bottomViewShowed:(BOOL)bottomViewShowed;

@end
