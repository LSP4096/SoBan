//
//  SOFlowChartView.h
//  souban
//
//  Created by Rawlings on 16/1/22.
//  Copyright © 2016年 wajiang. All rights reserved.
//
#import <UIKit/UIKit.h>

// ===================================================================================
#pragma mark - API
// ===================================================================================
@interface SOFlowChartView : UIView
/**
 *  Insure image.size are uniform
 *
 *  @param images
 *  @param headers
 *  @param progress Since 1 (1 ~ arrCount)
 *
 *  @return frame origin default (0, 0)
 */
+ (instancetype)chartWithImages:(NSArray<UIImage *> *)images Headers:(NSArray<NSString *> *)headers progress:(NSInteger)progress;
/**
 *  Insure image.size are uniform
 *
 *  @param images
 *  @param headers
 *  @param progress Since 1 (1 ~ arrCount)
 *
 *  @return frame origin default (0, 0)
 */
- (instancetype)initWithImages:(NSArray<UIImage *> *)images Headers:(NSArray<NSString *> *)headers progress:(NSInteger)progress;
@end


// ===================================================================================
#pragma mark - Private
// ===================================================================================
@interface SOFlowChartUnitView : UIView
+ (instancetype)chartUnitWithWidth:(CGFloat)width
                             index:(NSInteger)index
                          progress:(NSInteger)progress
                             image:(UIImage *)image
                            header:(NSString *)header;
/// Index since 0
- (instancetype)initWithWidth:(CGFloat)width
                        index:(NSInteger)index
                     progress:(NSInteger)progress
                        image:(UIImage *)image
                       header:(NSString *)header;
@end