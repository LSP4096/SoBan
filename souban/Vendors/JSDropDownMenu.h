//
//  JSDropDownMenu.h
//  JSDropDownMenu
//
//  Created by Jsfu on 15-1-12.
//  Copyright (c) 2015年 jsfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSIndexPath.h"

#pragma mark - data source protocol
@class JSDropDownMenu;

@protocol JSDropDownMenuDataSource <NSObject>

@required
- (NSInteger)menu:(JSDropDownMenu *)menu leftNumberOfRowsInColumn:(NSInteger)column;

- (NSInteger)menu:(JSDropDownMenu *)menu rightNumberOfRowsInColumn:(NSInteger)column leftRow:(NSInteger)leftRow;

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath;

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column;

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu;

/**
 * 表视图显示时，左边表显示比例
 */
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column;

/**
 * 表视图显示时，是否需要两个表显示
 */
- (BOOL)haveRightTableViewInColumn:(NSInteger)column;

/**
 * 返回当前菜单选中行
 */
- (NSInteger)leftSelectedRowInColumn:(NSInteger)column;

- (NSInteger)rightSelectedRowForLeftRow:(NSInteger)leftRow inColumn:(NSInteger)column;

@optional


@end

#pragma mark - delegate
@protocol JSDropDownMenuDelegate <NSObject>

@optional
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath;
/**
 *  筛选完毕将要隐藏的时候
 */
- (void)menuWillDismiss:(JSDropDownMenu *)menu;
@end

#pragma mark - interface


@interface JSDropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<JSDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id<JSDropDownMenuDelegate> delegate;

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
- (instancetype)initMapDropWithFrame:(CGRect)frame;

- (void)dismissMenu;

- (void)reloadHeaderForColumn:(NSInteger)column;
- (void)setHeaderForColumnWithTitles:(NSArray *)titles;
@end
