//
//  SOBuildingStationListViewController.m
//  souban
//
//  Created by 周国勇 on 11/12/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingStationListViewController.h"
#import "SOStationBuildingSummary.h"
#import "SOBuildingListEmptyView.h"
#import "SORefreshHeader.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "OMHUDManager.h"
#import "OMHTTPClient+Building.h"
#import "NSBundle+Nib.h"
#import "UIView+Layout.h"
#import "SOStationBuildingListCell.h"
#import <UIScrollView+EmptyDataSet.h>
#import "UIColor+OM.h"
#import "SOBuildingStationListHeaderView.h"
#import "SOPageModel.h"
#import "SOCity.h"


@interface SOBuildingStationListViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) NSMutableArray<SOStationBuildingSummary *> *buildings;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;
@property (strong, nonatomic) SOBuildingStationListHeaderView *tableViewHeaderView;

@end


@implementation SOBuildingStationListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"创业办公专题";

    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    __weak __typeof(&*self) weakSelf = self;
    SORefreshHeader *header = [SORefreshHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    self.tableView.refreshHeader = header;
    [self.tableView.refreshHeader beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

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

            self.tableViewHeaderView.height = [self.tableViewHeaderView height];
            self.tableView.tableHeaderView = self.buildings.count == 0?nil:self.tableViewHeaderView;
            [self.tableView reloadData];
        }
    };

    dispatch_group_enter(group);

    [[OMHTTPClient realClient] fetchStationBuildingListWithPage:[SOPageModel pageWithLimit:kPageSize] completion:refreshBlock];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if ([self.tableView.refreshHeader isRefreshing]) {
            [self.tableView.refreshHeader endRefreshing];
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
    [[OMHTTPClient realClient] fetchStationBuildingListWithPage:[SOPageModel pageWithObjects:self.buildings limit:kPageSize] completion:loadMoreBlock];
}

#pragma mark - EmptyView Delegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    UIColor *color = [UIColor at_warmGreyColor]; // select needed color
    NSString *string = @"暂时没有数据";
    NSDictionary *attrs = @{NSForegroundColorAttributeName : color};
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    return attrStr;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.width / 375.0 * 250;
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
    SOStationBuildingListCell *cell = [tableView dequeueReusableCellWithIdentifier:[SOStationBuildingListCell reuseIdentifier]];
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

- (NSMutableArray<SOStationBuildingSummary *> *)buildings
{
    if (!_buildings) {
        _buildings = [NSMutableArray new];
    }
    return _buildings;
}

- (SOBuildingStationListHeaderView *)tableViewHeaderView
{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [NSBundle loadNibFromMainBundleWithClass:[SOBuildingStationListHeaderView class]];
        if ([[SOCity city] cityDataForName:SOCityDataNameIncubator]) {
            _tableViewHeaderView.contentLabel.text = [[SOCity city] cityDataForName:SOCityDataNameIncubator];
        }
    }
    return _tableViewHeaderView;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushToStationDetail"]) {
        OMBaseViewController *controller = segue.destinationViewController;
        NSIndexPath *indexpath = self.tableView.indexPathForSelectedRow;
        SOStationBuildingSummary *building = self.buildings[indexpath.row];
        controller.title = building.name;
        controller.userInfo = @{ @"buildingId" : building.uniqueId };
        [self.tableView deselectRowAtIndexPath:indexpath animated:YES];
    }
}


@end
