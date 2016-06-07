//
//  SOMyOrderViewController.m
//  souban
//
//  Created by JiaHao on 10/27/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOMyOrderViewController.h"
#import "SOMyOrderViewCell.h"
#import "SOMyCollectionTableSectionHeader.h"
#import "SOOrderBuilding.h"
#import "OMHTTPClient+User.h"
#import "OMHUDManager.h"
#import "SORefreshHeader.h"
#import "SOOrderBuildingSummary.h"
#import "kCommonMacro.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "OMNavigationManager.h"
#import "NSNotificationCenter+OM.h"
#import "SOPageModel.h"

#define kPageSize 10


@interface SOMyOrderViewController ()

@property (strong, nonatomic) NSMutableArray *buildings;
@property (strong, nonatomic) SOOrderBuildingSummary *buildingSummary;
@property (weak, nonatomic) IBOutlet UILabel *orderBuildingLabel;

@end


@implementation SOMyOrderViewController


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView.tableFooterView = [UIView new];
    self.title = @"我的预约";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kUserLoginSuccess object:nil];

    __weak __typeof(&*self) weakSelf = self;
    SORefreshHeader *header = [SORefreshHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    self.tableView.refreshHeader = header;
    [self.tableView.refreshHeader beginRefreshing];
}


#pragma mark - Private Method

- (void)refreshData
{
    [[OMHTTPClient realClient] fetchMyOrderListWithPageModel:[SOPageModel pageWithLimit:kPageSize] completion:^(SOOrderBuildingSummary *resultObject, NSError *error) {
        if ([self.tableView.refreshHeader isRefreshing]) {
            [self.tableView.refreshHeader endRefreshing];
        }
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
        }else{
            self.buildingSummary = resultObject;
            self.orderBuildingLabel.text = [NSString stringWithFormat:@"共预订%@套房源",self.buildingSummary.totalNumber];
            
            __weak __typeof(&*self)weakSelf = self;
            [self.tableView addInfiniteScrollingWithActionHandler:^{
                [weakSelf loadMoreData];
            }];
            self.tableView.showsInfiniteScrolling = resultObject.list.count == kPageSize;
            [self.tableView reloadData];
        }
    }];
}

- (void)loadMoreData
{
    [[OMHTTPClient realClient] fetchMyOrderListWithPageModel:[SOPageModel pageWithObjects:self.buildingSummary.list limit:kPageSize] completion:^(SOOrderBuildingSummary *resultObject, NSError *error) {
            [self.tableView.infiniteScrollingView stopAnimating];
            if (error) {
                [OMHUDManager showErrorWithStatus:error.errorMessage];
            } else {
                self.tableView.showsInfiniteScrolling = [resultObject.list count] == kPageSize;
                [self.buildingSummary.list addObjectsFromArray:resultObject.list];
                [self.tableView reloadData];
            }
    }];
}

- (void)toDetailPage:(UIButton *)btn
{
    SOOrderBuilding *building = self.buildingSummary.list[btn.tag];
    [OMNavigationManager pushControllerWithStoryboardName:@"Building" identifier:@"SOBuildingDetailViewController" userInfo:@{ @"buildingId" : building.uniqueId,
                                                                                                                               @"title" : building.buildingName }];
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.buildingSummary.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    SOOrderBuilding *building = self.buildingSummary.list[section];
    return building.rooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SOMyOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SOMyOrderViewCell reuseIdentifier] forIndexPath:indexPath];
    SOOrderBuilding *building = self.buildingSummary.list[indexPath.section];
    [cell configWithBuilding:building.rooms[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SOMyCollectionTableSectionHeader *header = [[NSBundle mainBundle] loadNibNamed:@"SOMyCollectionTableSectionHeader" owner:nil options:nil].firstObject;
    SOOrderBuilding *building = self.buildingSummary.list[section];
    header.sectionTitleLabel.text = building.buildingName;
    [header.toDetailButton addTarget:self action:@selector(toDetailPage:) forControlEvents:UIControlEventTouchUpInside];
    header.toDetailButton.tag = section;
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SOOrderBuilding *building = self.buildingSummary.list[indexPath.section];
    [OMNavigationManager pushControllerWithStoryboardName:@"Building" identifier:@"SOBuildingDetailViewController" userInfo:@{ @"buildingId" : building.uniqueId,
                                                                                                                               @"title" : building.buildingName }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


#pragma mark - Getters and Setters

- (NSMutableArray *)buildings
{
    if (_buildings == nil) {
        _buildings = [[NSMutableArray alloc] init];
    }
    return _buildings;
}

@end
