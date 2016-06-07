//
//  SOMyCollectionViewController.m
//  souban
//
//  Created by JiaHao on 10/27/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOMyCollectionViewController.h"
#import "SOMyCollectionViewCell.h"
#import "SOBuildingSummary.h"
#import "SOMyCollectionTableSectionHeader.h"
#import "SOCollectBuilding.h"
#import "OMHTTPClient+User.h"
#import "OMHUDManager.h"
#import "SOCollectBuildingSummary.h"
#import "kCommonMacro.h"
#import "SORefreshHeader.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "OMNavigationManager.h"
#import "OMHTTPClient+Building.h"
#import "NSNotificationCenter+OM.h"
#import "SOPageModel.h"


@interface SOMyCollectionViewController () <SOMyCollectionViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *buildings;
@property (strong, nonatomic) SOCollectBuildingSummary *buildingSummary;
@property (weak, nonatomic) IBOutlet UILabel *totalBuidingLabel;

@end


@implementation SOMyCollectionViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的收藏";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kUserLoginSuccess object:nil];

    __weak __typeof(&*self) weakSelf = self;
    SORefreshHeader *header = [SORefreshHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.refreshHeader = header;
    [self.tableView.refreshHeader beginRefreshing];
}


#pragma mark - Private Method

- (void)toDetailPage:(UIButton *)btn
{
    SOCollectBuilding *building = self.buildingSummary.list[btn.tag];
    [OMNavigationManager pushControllerWithStoryboardName:@"Building" identifier:@"SOBuildingDetailViewController" userInfo:@{ @"buildingId" : building.uniqueId,
                                                                                                                               @"title" : building.buildingName }];
}

- (void)uncollectBuilding:(SOCollectBuildingRoom *)room Building:(SOCollectBuilding *)buiding
{
    [[OMHTTPClient realClient] unStarRoomWithRoomId:room.roomId completion:^(id resultObject, NSError *error) {
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
        }else{
            [OMHUDManager showSuccessWithStatus:@"取消收藏成功"];
            NSUInteger section = [self.buildingSummary.list indexOfObject:buiding];
            NSUInteger row = [buiding.rooms indexOfObject:room];
            
            if (buiding.rooms.count == 1) {
                [self.buildingSummary.list removeObject:buiding];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                [buiding.rooms removeObject:room];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            NSInteger number = self.buildingSummary.totalNumber.integerValue - 1;
            self.buildingSummary.totalNumber = @(number);
            self.totalBuidingLabel.text = [NSString stringWithFormat:@"共收藏%@套房源",@(number)];
            
        }
    }];
}


- (void)refreshData
{
    [[OMHTTPClient realClient] fetchMyCollectionListWithPageModel:[SOPageModel pageWithLimit:kPageSize] completion:^(SOCollectBuildingSummary *resultObject, NSError *error) {
        
        if ([self.tableView.refreshHeader isRefreshing]) {
            [self.tableView.refreshHeader endRefreshing];
        }
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
        }else{
            
            self.buildingSummary = resultObject;
            self.totalBuidingLabel.text = [NSString stringWithFormat:@"共收藏%@套房源",self.buildingSummary?self.buildingSummary.totalNumber:@"0"];
            
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
    [[OMHTTPClient realClient] fetchMyCollectionListWithPageModel:[SOPageModel pageWithObjects:self.buildingSummary.list limit:kPageSize] completion:^(SOCollectBuildingSummary *resultObject, NSError *error) {
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


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.buildingSummary.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    SOCollectBuilding *building = self.buildingSummary.list[section];
    return building.rooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SOMyCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SOMyCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    cell.delegate = self;
    SOCollectBuilding *building = self.buildingSummary.list[indexPath.section];
    [cell configWithBuilding:building.rooms[indexPath.row] Building:building];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SOCollectBuilding *building = self.buildingSummary.list[indexPath.section];
    [OMNavigationManager pushControllerWithStoryboardName:@"Building" identifier:@"SOBuildingDetailViewController" userInfo:@{ @"buildingId" : building.uniqueId,
                                                                                                                               @"title" : building.buildingName }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SOMyCollectionTableSectionHeader *header = [[NSBundle mainBundle] loadNibNamed:@"SOMyCollectionTableSectionHeader" owner:nil options:nil].firstObject;
    SOCollectBuilding *building = self.buildingSummary.list[section];
    header.sectionTitleLabel.text = building.buildingName;
    [header.toDetailButton addTarget:self action:@selector(toDetailPage:) forControlEvents:UIControlEventTouchUpInside];
    header.toDetailButton.tag = section;
    return header;
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
