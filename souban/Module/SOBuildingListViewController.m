//
//  SOBuildingListViewController.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingListViewController.h"
#import "SOBuildingListCell.h"
#import "SOBuildingSummary.h"
#import "OMHTTPClient+Building.h"
#import <MJRefresh.h>
#import "SORefreshHeader.h"
#import "OMHUDManager.h"
#import <UIScrollView+SVInfiniteScrolling.h>
#import "SODropDownMenuManager.h"
#import "UIView+Layout.h"
#import "UIColor+OM.h"
#import <Masonry.h>
#import "SOScreenItems.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "NSBundle+Nib.h"
#import "SOBuildingListEmptyView.h"
#import "SOBuildingDetailViewController.h"
#import "NSNotificationCenter+OM.h"
#import "SOBuildingMapViewController.h"
#import "SOPageModel.h"
#import "SOProgressStatusBar.h"
#import "NSDate+CC.h"
#import "NSString+CC.h"
#import "GVUserDefaults+OM.h"
#import "OMResponse.h"
#import "UIStoryboard+SO.h"
#import "OMNavigationManager.h"


@interface SOBuildingListViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SODropDownMenuManagerDelegate>

@property (strong, nonatomic) NSMutableArray<SOBuildingSummary *> *buildings;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;

@property (strong, nonatomic) SOBuildingListEmptyView *emptyView;
@property (nonatomic) BOOL shouldDisplayEmptyView;
@property (weak, nonatomic) SOProgressStatusBar *progressBar;
@property (strong, nonatomic) NSNumber *roomCount; // 新增房源数量
@property (strong, nonatomic) SOBuildingMapViewController *mapController;
@end


@implementation SOBuildingListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    __weak __typeof(&*self) weakSelf = self;
    SORefreshHeader *header = [SORefreshHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    self.tableView.refreshHeader = header;
    [self.tableView.refreshHeader beginRefreshing];

    if ([self hideScreenBar]) {
        self.tableViewTopConstraint.constant = 0;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationController.navigationBar.barTintColor = nil;

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        view.layer.borderColor = [UIColor at_warmGreyColor].CGColor;
        view.layer.borderWidth = 0.5;
        UISearchBar *searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
        [view addSubview:searchbar];
        [searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left);
            make.right.equalTo(view.mas_right);
            make.top.equalTo(view.mas_top);
            make.bottom.equalTo(view.mas_bottom);
        }];
        searchbar.text = [self keyword];
        searchbar.delegate = self;
        searchbar.returnKeyType = UIReturnKeySearch;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.titleView = view;
    } else {
        [self.view addSubview:self.menuManager.dropDownMenu];
        SOProgressStatusBar *bar = [NSBundle loadNibFromMainBundleWithClass:[SOProgressStatusBar class]];
        bar.layer.cornerRadius = 4;
        bar.layer.masksToBounds = YES;
        [self.view addSubview:bar];
        [bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.menuManager.dropDownMenu.mas_bottom).with.offset(10);
            make.left.equalTo(self.view.mas_left).with.offset(10);
            make.right.equalTo(self.view.mas_right).with.offset(-10);
            make.height.mas_equalTo(40);
        }];
        self.progressBar = bar;
        [self.progressBar hide];
    }
    
    [NSNotificationCenter registerNotificationWithObserver:self selector:@selector(cityChanged:) name:kCityChanged];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NetWork

- (void)refreshData
{
    dispatch_group_t group = dispatch_group_create();

    void (^refreshBlock)(id resultObject, NSError *error) = ^(id resultObject, NSError *error) {
        dispatch_group_leave(group);
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
        } else {
            __weak __typeof(&*self)weakSelf = self;
            [self.tableView addInfiniteScrollingWithActionHandler:^{
                [weakSelf loadMoreData];
            }];
            self.tableView.showsInfiniteScrolling = [resultObject count] == kPageSize;
            [self.buildings removeAllObjects];
            [self.buildings addObjectsFromArray:resultObject];
            self.shouldDisplayEmptyView = [self.buildings count] == 0;
            [self.tableView reloadData];
        }
    };

    if ([self hideScreenBar]) {
        dispatch_group_enter(group);
        [[OMHTTPClient realClient] fetchBuildingListWithKeyword:[self keyword] page:[SOPageModel pageWithLimit:kPageSize] completion:refreshBlock];
    } else {
        dispatch_group_enter(group);
        [[OMHTTPClient realClient] fetchBuildingListWithScreenModel:self.menuManager.screenModel page:[SOPageModel pageWithLimit:kPageSize] completion:refreshBlock];
        // 获取筛选条目
        if (!self.menuManager.screenItems) {
            dispatch_group_enter(group);
            [[OMHTTPClient realClient] fetchScreenItemsWithCompletion:^(id resultObject, NSError *error) {
                dispatch_group_leave(group);
                if (error) {
                    [OMHUDManager showErrorWithStatus:error.errorMessage];
                } else {
                    self.menuManager.screenItems = resultObject;
                    self.menuManager.screenModel = [SOBuildingScreenModel new];
                }
            }];
        }
        // 获取新增房源数量
        NSString *dateString = [GVUserDefaults standardUserDefaults].lastNotifiDate;
        if (![[dateString dateWithFormate:DEFAULT_DATE_FORMATE] isToday]) {
            dispatch_group_enter(group);
            [[OMHTTPClient realClient] getNewRoomCountWithCompletion:^(NSDictionary *resultObject, NSError *error) {
                dispatch_group_leave(group);
                if (error) {
                    [OMHUDManager showErrorWithStatus:error.errorMessage];
                } else {
                    self.roomCount = resultObject[@"roomCount"];
                }
            }];
        }
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if ([self.tableView.refreshHeader isRefreshing]) {
            [self.tableView.refreshHeader endRefreshing];
        }
        NSString *dateString = [GVUserDefaults standardUserDefaults].lastNotifiDate;

        if (![[dateString dateWithFormate:DEFAULT_DATE_FORMATE] isToday] && self.roomCount && self.roomCount.integerValue != 0) {
            [GVUserDefaults standardUserDefaults].lastNotifiDate = [[NSDate date] stringWithFormate:DEFAULT_DATE_FORMATE];
            [self.progressBar showWithMessage:[NSString stringWithFormat:@"共新增%@套房源", self.roomCount]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.progressBar hideWithAnimation];
            });
        }
    });
}

- (void)loadMoreData
{
    void (^loadMoreBlock)(id resultObject, NSError *error) = ^(id resultObject, NSError *error) {
        [self.tableView.infiniteScrollingView stopAnimating];
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
        } else {
            self.tableView.showsInfiniteScrolling = [resultObject count] == kPageSize;
            
            [self.buildings addObjectsFromArray:resultObject];
            [self.tableView reloadData];
        }
    };
    if ([self hideScreenBar]) {
        [[OMHTTPClient realClient] fetchBuildingListWithKeyword:[self keyword] page:[SOPageModel pageWithObjects:self.buildings limit:kPageSize] completion:loadMoreBlock];
    } else {
        [[OMHTTPClient realClient] fetchBuildingListWithScreenModel:self.menuManager.screenModel page:[SOPageModel pageWithObjects:self.buildings limit:kPageSize] completion:loadMoreBlock];
    }
}

#pragma mark - Notification
- (void)cityChanged:(NSNotification *)notification {
    if (notification.userInfo[@"city"]) {
        [self.menuManager.dropDownMenu dismissMenu];
        self.menuManager.screenItems = nil;
        self.menuManager.screenModel = nil;
        [self.tableView.refreshHeader beginRefreshing];
    }
}

#pragma mark - SODropDownMenuManagerDelegate
- (void)needRefreshData
{
    [self.tableView.refreshHeader beginRefreshing];
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.width / 375.0 * 250;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SOBuildingDetailViewController *controller = [[UIStoryboard building] instantiateViewControllerWithIdentifier:[SOBuildingDetailViewController storyboardIdentifier]];

    SOBuildingSummary *building = self.buildings[indexPath.row];
    controller.title = building.name;
    controller.userInfo = @{ @"buildingId" : building.uniqueId,
                             @"screenModel" : self.menuManager.screenModel };
    [OMNavigationManager pushController:controller];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.buildings.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SOBuildingListCell *cell = [tableView dequeueReusableCellWithIdentifier:[SOBuildingListCell reuseIdentifier]];
    [cell configCellWithModel:self.buildings[indexPath.row]];
    return cell;
}

#pragma mark - SearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSMutableDictionary *dic = self.userInfo.mutableCopy;
    dic[@"keyword"] = searchBar.text;
    self.userInfo = dic;
    [searchBar resignFirstResponder];
    [self.tableView.refreshHeader beginRefreshing];
}

#pragma mark - Getter & Setter
- (SOBuildingListEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [NSBundle loadNibFromMainBundleWithClass:[SOBuildingListEmptyView class]];
        _emptyView.top = self.tableView.top + 64;
        if ([self hideScreenBar]) {
            _emptyView.top = self.tableView.top + 64 - 45;
        }
        _emptyView.width = self.tableView.width;
        _emptyView.height = self.tableView.height - 64;
    }
    return _emptyView;
}

- (NSMutableArray<SOBuildingSummary *> *)buildings
{
    if (!_buildings) {
        _buildings = [NSMutableArray new];
    }
    return _buildings;
}

- (SODropDownMenuManager *)menuManager
{
    if (!_menuManager) {
        _menuManager = [[SODropDownMenuManager alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
        _menuManager.delegate = self;
    }
    return _menuManager;
}

- (BOOL)hideScreenBar
{
    return [self.userInfo[@"hideScreenBar"] boolValue];
}

- (NSString *)keyword
{
    return self.userInfo[@"keyword"];
}

- (void)setShouldDisplayEmptyView:(BOOL)shouldDisplayEmptyView
{
    if (shouldDisplayEmptyView == _shouldDisplayEmptyView) {
        return;
    }
    if (shouldDisplayEmptyView) {
        [self.view addSubview:[self emptyView]];
        self.emptyView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.emptyView.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.emptyView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.emptyView removeFromSuperview];
        }];
    }
    _shouldDisplayEmptyView = shouldDisplayEmptyView;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}
@end
