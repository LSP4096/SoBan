//
//  JSDropDownMenu.m
//  JSDropDownMenu
//
//  Created by Jsfu on 15-1-12.
//  Copyright (c) 2015年 jsfu. All rights reserved.
//

#import "JSDropDownMenu.h"
#import "JSDropDownMenuTableViewCell.h"
#import "UIColor+OM.h"
#import "JSDropDownMenuHeaderCell.h"
#import "UIView+Layout.h"

#pragma mark - menu implementation


@interface JSDropDownMenu ()
@property (nonatomic, assign) NSInteger currentSelectedMenudIndex;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *bottomShadow;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (strong, nonatomic) UICollectionView *headerCollectionView;
@property (strong, nonatomic) UIImageView *backgroundImageView;

@property (nonatomic, assign) BOOL mapType;

//data source
@property (nonatomic, copy) NSArray *array;
@property (nonatomic, assign) BOOL hadSelected;

@end


@implementation JSDropDownMenu

#pragma mark - setter
- (void)setDataSource:(id<JSDropDownMenuDataSource>)dataSource
{
    _dataSource = dataSource;

    //configure view
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    } else {
        _numOfMenu = 1;
    }
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.headerCollectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / [dataSource numberOfColumnsInMenu:self], self.frame.size.height);
    [_headerCollectionView reloadData];
}

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    if (self) {
        _origin = origin;
        _currentSelectedMenudIndex = -1;
        _show = NO;

        _hadSelected = NO;

        //header collection view init
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _headerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, height) collectionViewLayout:layout];
        _headerCollectionView.dataSource = self;
        _headerCollectionView.delegate = self;
        _headerCollectionView.scrollEnabled = NO;
        _headerCollectionView.backgroundColor = [UIColor whiteColor];
        UINib *nib = [UINib nibWithNibName:@"JSDropDownMenuHeaderCell" bundle:nil];
        [_headerCollectionView registerNib:nib forCellWithReuseIdentifier:@"JSDropDownMenuHeaderCell"];
        [self addSubview:_headerCollectionView];

        //tableView init
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStyleGrouped];
        _leftTableView.rowHeight = 49;
        _leftTableView.separatorColor = [UIColor colorWithRed:220.f / 255.0f green:220.f / 255.0f blue:220.f / 255.0f alpha:1.0];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStyleGrouped];
        _rightTableView.rowHeight = 49;
        _rightTableView.separatorColor = [UIColor colorWithRed:220.f / 255.0f green:220.f / 255.0f blue:220.f / 255.0f alpha:1.0];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _leftTableView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
        //        _rightTableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        _rightTableView.backgroundColor = [UIColor whiteColor];

        nib = [UINib nibWithNibName:@"JSDropDownMenuTableViewCell" bundle:nil];
        [_leftTableView registerNib:nib forCellReuseIdentifier:@"JSDropDownMenuTableViewCell"];
        [_rightTableView registerNib:nib forCellReuseIdentifier:@"JSDropDownMenuTableViewCell"];

        self.autoresizesSubviews = NO;
        _leftTableView.autoresizesSubviews = NO;
        _rightTableView.autoresizesSubviews = NO;

        //self tapped
        self.backgroundColor = [UIColor whiteColor];

        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];

        //add bottom shadow
        _bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, screenSize.width, 0.5)];
        _bottomShadow.backgroundColor = [UIColor grayLineColor];
        [self addSubview:_bottomShadow];
    }
    return self;
}

- (instancetype)initMapDropWithFrame:(CGRect)frame
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:frame];
    if (self) {
        _origin = frame.origin;
        _currentSelectedMenudIndex = -1;
        _show = NO;

        _hadSelected = NO;
        _mapType = YES;

        //header collection view init
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        self.clipsToBounds = YES;
        _headerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, frame.size.height) collectionViewLayout:layout];

        _headerCollectionView.dataSource = self;
        _headerCollectionView.delegate = self;
        _headerCollectionView.scrollEnabled = NO;
        _headerCollectionView.backgroundColor = [UIColor whiteColor];
        UINib *nib = [UINib nibWithNibName:@"JSDropDownMenuHeaderCell" bundle:nil];
        [_headerCollectionView registerNib:nib forCellWithReuseIdentifier:@"JSDropDownMenuHeaderCell"];
        [self addSubview:_headerCollectionView];


        //tableView init
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStyleGrouped];
        _leftTableView.rowHeight = 49;
        _leftTableView.separatorColor = [UIColor colorWithRed:220.f / 255.0f green:220.f / 255.0f blue:220.f / 255.0f alpha:1.0];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width, 20 + self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStyleGrouped];
        _rightTableView.rowHeight = 49;
        _rightTableView.separatorColor = [UIColor colorWithRed:220.f / 255.0f green:220.f / 255.0f blue:220.f / 255.0f alpha:1.0];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;


        _leftTableView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];


        [_leftTableView setBackgroundColor:[UIColor clearColor]];

        _rightTableView.backgroundColor = [UIColor whiteColor];

        nib = [UINib nibWithNibName:@"JSDropDownMenuTableViewCell" bundle:nil];
        [_leftTableView registerNib:nib forCellReuseIdentifier:@"JSDropDownMenuTableViewCell"];
        [_rightTableView registerNib:nib forCellReuseIdentifier:@"JSDropDownMenuTableViewCell"];

        self.autoresizesSubviews = NO;
        _leftTableView.autoresizesSubviews = NO;
        _rightTableView.autoresizesSubviews = NO;


        //self tapped
        self.backgroundColor = [UIColor whiteColor];

        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        _backGroundView.userInteractionEnabled = YES;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];

        //add bottom shadow
        //        _bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, screenSize.width, 0.5)];
        //        _bottomShadow.backgroundColor = [UIColor grayLineColor];
        //        [self addSubview:_bottomShadow];

        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_map_filter_1"]];


        [self.superview addSubview:self.backgroundImageView];
        self.backgroundImageView.frame = CGRectMake(5, 5 + self.frame.origin.y + self.frame.size.height, self.frame.size.width + 10, 0);
    }
    return self;
}

- (void)dismissMenu
{
    _show = NO;
    [self.headerCollectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:_currentSelectedMenudIndex inSection:0] animated:YES];
    _currentSelectedMenudIndex = -1;
    [self.delegate menuWillDismiss:self];
    [self animateBackGroundView:self.backGroundView show:NO complete:^{
        [self animateLeftTableView:_leftTableView rightTableView:_rightTableView show:NO complete:^{
            
        }];
    }];
}

- (void)reloadHeaderForColumn:(NSInteger)column
{
    JSDropDownMenuHeaderCell *cell = (JSDropDownMenuHeaderCell *)[self.headerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:column inSection:0]];
    cell.titleLabel.text = [self.dataSource menu:self titleForColumn:column];
}

- (void)setHeaderForColumnWithTitles:(NSArray *)titles
{
    if (self.mapType) {
        for (NSString *title in titles) {
            JSDropDownMenuHeaderCell *cell = (JSDropDownMenuHeaderCell *)[self.headerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[titles indexOfObject:title] inSection:0]];
            cell.titleLabel.text = title;
        }
    } else {
        for (NSString *title in titles) {
            JSDropDownMenuHeaderCell *cell = (JSDropDownMenuHeaderCell *)[self.headerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[titles indexOfObject:title] + 1 inSection:0]];
            cell.titleLabel.text = title;
        }
    }
}

#pragma mark - gesture handle
- (void)menuTappedWithIndexPath:(NSIndexPath *)indexPath
{
    //    BOOL haveRightTableView = [_dataSource haveRightTableViewInColumn:tapIndex];
    _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg_map_filter_%ld", (long)(indexPath.row + 1)]]];
    BOOL show = indexPath.row != _currentSelectedMenudIndex;
    _currentSelectedMenudIndex = show ? indexPath.row : -1;
    if (show) {
        self.leftTableView.backgroundColor = [self.dataSource haveRightTableViewInColumn:_currentSelectedMenudIndex] ? [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1] : [UIColor whiteColor];
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    } else {
        [self.delegate menuWillDismiss:self];
    }

    [self animateBackGroundView:self.backGroundView show:show complete:^{
        [self animateLeftTableView:_leftTableView rightTableView:_rightTableView show:show complete:^{
            
        }];
    }];
}

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    [self.headerCollectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:_currentSelectedMenudIndex inSection:0] animated:YES];
    _show = NO;
    _currentSelectedMenudIndex = -1;
    [self.delegate menuWillDismiss:self];
    [self animateBackGroundView:self.backGroundView show:NO complete:^{

        [self animateLeftTableView:_leftTableView rightTableView:_rightTableView show:NO complete:^{
            
        }];
    }];
}

#pragma mark - animation method

- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void (^)())complete
{
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        [self.backgroundImageView removeFromSuperview];
        [self.superview addSubview:self.backgroundImageView];
        [self.backgroundImageView.superview addSubview:self];


        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = self.mapType?[UIColor clearColor]:[UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

/**
 *动画显示下拉菜单
 */
- (void)animateLeftTableView:(UITableView *)leftTableView rightTableView:(UITableView *)rightTableView show:(BOOL)show complete:(void (^)())complete
{
    CGFloat ratio = [_dataSource widthRatioOfLeftColumn:_currentSelectedMenudIndex];

    if (show) {
        CGFloat leftTableViewHeight = 0;

        CGFloat rightTableViewHeight = 0;

        if (leftTableView) {
            //            leftTableView.backgroundView

            leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width * ratio, 0);
            [self.superview addSubview:leftTableView];

            NSInteger maxCount = [self.dataSource menu:self leftNumberOfRowsInColumn:0];
            //            NSInteger minCount = [self.dataSource menu:self leftNumberOfRowsInColumn:0];
            for (NSInteger i = 0; i < [self.dataSource numberOfColumnsInMenu:self]; i++) {
                maxCount = maxCount > [self.dataSource menu:self leftNumberOfRowsInColumn:i] ? maxCount : [self.dataSource menu:self leftNumberOfRowsInColumn:i];
                //                minCount = minCount < [self.dataSource menu:self leftNumberOfRowsInColumn:i]?minCount:[self.dataSource menu:self leftNumberOfRowsInColumn:i];
            }
            //            NSInteger averageCount = (maxCount+minCount)/2;
            leftTableViewHeight = maxCount * leftTableView.rowHeight;
            if (leftTableViewHeight >= [UIScreen mainScreen].bounds.size.height - 64 - 50 - 44) {
                leftTableViewHeight = [UIScreen mainScreen].bounds.size.height - 64 - 50 - 44 - 50;
            }
        }

        if (rightTableView) {
            rightTableView.frame = CGRectMake(_origin.x + leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width * (1 - ratio), 0);

            [self.superview addSubview:rightTableView];

            rightTableViewHeight = leftTableViewHeight;
        }

        CGFloat tableViewHeight = MAX(leftTableViewHeight, rightTableViewHeight);
        //        CGFloat minHeight = MAX(tableViewHeight, 256);

        //        [UIView animateWithDuration:0.2 animations:^{
        //            if (leftTableView) {
        //                leftTableView.frame = CGRectMake(_origin.x,self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, tableViewHeight);
        //            }
        //            if (rightTableView) {
        //                rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), tableViewHeight);
        //            }
        //        }];
        self.backgroundImageView.height = 0;
        self.backgroundImageView.hidden = NO;
        self.backgroundImageView.frame = CGRectMake(5, 5 + self.frame.origin.y + self.frame.size.height, self.frame.size.width + 10, 0);
        [UIView animateWithDuration:0.5
            delay:0
            usingSpringWithDamping:0.7
            initialSpringVelocity:3
            options:UIViewAnimationOptionCurveEaseInOut
            animations:^{
                             
                             NSInteger edgeY = self.mapType?20:0;
                             if (leftTableView) {
                                 leftTableView.frame = CGRectMake(_origin.x,edgeY+ self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, tableViewHeight);
                             }
                             if (rightTableView) {
                                 rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width,edgeY+ self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), tableViewHeight);
                             }
                             if (self.mapType) {
                                 self.backgroundImageView.frame = CGRectMake(5,5+self.frame.origin.y + self.frame.size.height, self.frame.size.width+10, tableViewHeight+25);
                             }
            }
            completion:^(BOOL finished){

            }];


    } else {
        [UIView animateWithDuration:0.2 animations:^{
            
            if (leftTableView) {
                leftTableView.height = 0;
//                leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, 0);
            }
            if (rightTableView) {
                rightTableView.height = 0;
//                rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), 0);
            }
            
            self.backgroundImageView.height = 0;
        } completion:^(BOOL finished) {
            self.backgroundImageView.hidden = YES;
            if (leftTableView) {
                [leftTableView removeFromSuperview];
            }
            if (rightTableView) {
                [rightTableView removeFromSuperview];
            }
        }];
    }
    complete();
}

#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JSIndexTableType tableType = _rightTableView == tableView ? JSIndexTableTypeRight : JSIndexTableTypeLeft;

    if (tableType == JSIndexTableTypeLeft) {
        return [self.dataSource menu:self leftNumberOfRowsInColumn:self.currentSelectedMenudIndex];
    } else {
        NSInteger selectedRow = [self.dataSource leftSelectedRowInColumn:self.currentSelectedMenudIndex];
        return [self.dataSource menu:self rightNumberOfRowsInColumn:_currentSelectedMenudIndex leftRow:selectedRow];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(JSDropDownMenuTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSIndexTableType tableType = _rightTableView == tableView ? JSIndexTableTypeRight : JSIndexTableTypeLeft;
    NSInteger leftSelectedRow = [self.dataSource leftSelectedRowInColumn:self.currentSelectedMenudIndex];

    if (tableType == JSIndexTableTypeLeft) {
        JSIndexPath *jsIndexPath = [JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex tableType:tableType leftRow:indexPath.row rightRow:0];
        NSString *title = [self.dataSource menu:self titleForRowAtIndexPath:jsIndexPath];
        BOOL haveRightTableView = [self.dataSource haveRightTableViewInColumn:self.currentSelectedMenudIndex];
        [cell configCellWithText:title selected:leftSelectedRow == indexPath.row showCheckImage:!haveRightTableView tableType:tableType showSeparatorLine:!haveRightTableView];
        if (indexPath.row == leftSelectedRow) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        JSIndexPath *jsIndexPath = [JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex tableType:tableType leftRow:leftSelectedRow rightRow:indexPath.row];
        NSString *title = [self.dataSource menu:self titleForRowAtIndexPath:jsIndexPath];
        NSInteger rightSelectedRow = [self.dataSource rightSelectedRowForLeftRow:leftSelectedRow inColumn:self.currentSelectedMenudIndex];

        [cell configCellWithText:title selected:rightSelectedRow == indexPath.row showCheckImage:YES tableType:tableType showSeparatorLine:YES];
        if (indexPath.row == rightSelectedRow) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"JSDropDownMenuTableViewCell";

    JSDropDownMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSIndexTableType tableType = tableView == _rightTableView ? JSIndexTableTypeRight : JSIndexTableTypeLeft;

    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        NSInteger leftSelectedRow = [self.dataSource leftSelectedRowInColumn:self.currentSelectedMenudIndex];
        JSIndexPath *jsindexPath = [JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex tableType:tableType leftRow:indexPath.row rightRow:0];
        if (tableView == _rightTableView) {
            jsindexPath = [JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex tableType:tableType leftRow:leftSelectedRow rightRow:indexPath.row];
        }
        [self.delegate menu:self didSelectRowAtIndexPath:jsindexPath];

        [self.rightTableView reloadData];
    }
}

#pragma mark - Collection View DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource numberOfColumnsInMenu:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSDropDownMenuHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JSDropDownMenuHeaderCell" forIndexPath:indexPath];
    NSString *title = [self.dataSource menu:self titleForColumn:indexPath.row];
    [cell configCellWithText:title displayLine:indexPath.row != [self.dataSource numberOfColumnsInMenu:self] - 1];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width / [self.dataSource numberOfColumnsInMenu:self], self.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentSelectedMenudIndex == indexPath.row) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    self.backgroundImageView.height = 0;
    [self menuTappedWithIndexPath:indexPath];
}

@end
