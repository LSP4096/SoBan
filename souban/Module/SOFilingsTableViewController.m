//
//  SOFilingsTableViewController.m
//  souban
//
//  Created by 周国勇 on 12/24/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOFilingsTableViewController.h"
#import "SOFilingTableViewCell.h"
#import "SORefreshHeader.h"
#import "OMHTTPClient+Explore.h"
#import "OMUser.h"
#import "SOWebViewController.h"
#import "UIStoryboard+SO.h"
#import "OMNavigationManager.h"
#import <UIScrollView+SVInfiniteScrolling.h>
#import "SOBuildingListEmptyView.h"
#import "NSBundle+Nib.h"
#import "UIView+Layout.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SOCommonSlideView.h"
#import "Masonry.h"
#import "SOFilingDetailViewController.h"
#import "UIColor+Hex.h"


@interface SOFilingsTableViewController () <UITableViewDelegate, UITableViewDataSource, SOCommonSlideViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *filings;
@property (nonatomic) SOFilingStep filingType;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic) BOOL shouldDisplayEmptyView;
@property (strong, nonatomic) SOBuildingListEmptyView *emptyView;
@property (weak, nonatomic) IBOutlet UIView *topContainerView;
@property (weak, nonatomic) IBOutlet UIView *spaceView;

@end


@implementation SOFilingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.filingType = SOFilingStepOne;
    SORefreshHeader *header = [SORefreshHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    self.tableView.refreshHeader = header;

    __weak __typeof(&*self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
    self.tableView.showsInfiniteScrolling = NO;

    [self.view bringSubviewToFront:self.addButton];

    SOCommonSlideView *slideView = [SOCommonSlideView slideViewWithTagsArray:@[ @"已报备", @"已带看", @"已跟进", @"已成交", @"已结佣" ]];
    [self.topContainerView addSubview:slideView];
    slideView.delegate = self;
    [slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topContainerView.mas_left);
        make.right.equalTo(weakSelf.topContainerView.mas_right);
        make.top.equalTo(weakSelf.topContainerView.mas_top);
        make.bottom.equalTo(weakSelf.topContainerView.mas_bottom).with.offset(-10);
    }];
    self.spaceView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView.refreshHeader beginRefreshing];
}

#pragma mark - Private
- (void)refreshData
{
    SOPageModel *model = [SOPageModel pageWithLimit:kPageSize];

    [[OMHTTPClient realClient] fetchFilingsWithUserId:[OMUser user].uniqueId page:model type:self.filingType completion:^(id resultObject, NSError *error) {
        [self.tableView.refreshHeader endRefreshing];
        if (!error.hudMessage) {
            [self.filings removeAllObjects];
            [self.filings addObjectsFromArray:resultObject];
            self.tableView.showsInfiniteScrolling = [resultObject count] >= kPageSize;
            self.shouldDisplayEmptyView = [resultObject count] == 0;
            [self.tableView reloadData];
        }
    }];
}

- (void)loadMoreData
{
    SOPageModel *model = [SOPageModel pageWithObjects:self.filings limit:kPageSize];
    [[OMHTTPClient realClient] fetchFilingsWithUserId:[OMUser user].uniqueId page:model type:self.filingType completion:^(id resultObject, NSError *error) {
        [self.tableView.infiniteScrollingView stopAnimating];
        if (!error.hudMessage) {
            [self.filings addObjectsFromArray:resultObject];
            self.tableView.showsInfiniteScrolling = [resultObject count] >= kPageSize;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Action
- (IBAction)infoTapped:(id)sender
{
    SOWebViewController *controller = [[UIStoryboard common] instantiateViewControllerWithIdentifier:[SOWebViewController storyboardIdentifier]];
    controller.userInfo = @{ @"url" : @"http://m.91souban.com/partners/about?type=1",
                             @"title" : @"搜办合伙人" };
    [OMNavigationManager pushController:controller];
}

- (IBAction)addFilingTapped:(id)sender
{
    [self performSegueWithIdentifier:@"pushToFilingDetail" sender:sender];
}

#pragma mark - CommonSlideView Delegate
- (void)slideView:(SOCommonSlideView *)slideView didSelectedTagWithIndex:(NSInteger)index button:(SOSlideButton *)button
{
    self.filingType = index + 1;
    [self.tableView.refreshHeader beginRefreshing];
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"pushToFilingDetail" sender:tableView];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SOFilingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SOFilingTableViewCell reuseIdentifier]];

    [cell configCellWithModel:self.filings[indexPath.row]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:[SOFilingTableViewCell reuseIdentifier] configuration:^(SOFilingTableViewCell *cell) {
        [cell configCellWithModel:self.filings[indexPath.row]];
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToFilingDetail"]) {
        if ([sender isEqual:self.addButton]) {
            OMBaseViewController *controller = segue.destinationViewController;
            controller.userInfo = @{ @"type" : @(SOFilingDetailViewControllerAdd) };
        } else if ([sender isEqual:self.tableView]) {
            NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
            SOFiling *filing = self.filings[indexPath.row];
            OMBaseViewController *controller = segue.destinationViewController;
            controller.navigationItem.title = @"报备详情";
            controller.userInfo = @{ @"type" : @(SOFilingDetailViewControllerNormal),
                                     @"filingId" : filing.uniqueId };
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

#pragma mark - Getter & Setter
- (NSMutableArray *)filings
{
    if (!_filings) {
        _filings = [NSMutableArray new];
    }
    return _filings;
}

- (SOBuildingListEmptyView *)emptyView
{
    __weak __typeof(&*self) weakSelf = self;
    if (!_emptyView) {
        _emptyView = [NSBundle loadNibFromMainBundleWithClass:[SOBuildingListEmptyView class]];
        _emptyView.top = weakSelf.tableView.top + 64;
        _emptyView.width = weakSelf.tableView.width;
        _emptyView.height = weakSelf.tableView.height - 64;
        [_emptyView configWithDescription:@"暂时没有报备" buttonTitle:@"立即报备" buttonAction:^{
            [weakSelf performSegueWithIdentifier:@"pushToFilingDetail" sender:weakSelf.addButton];
        }];
    }
    return _emptyView;
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
            self.addButton.hidden = shouldDisplayEmptyView;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.emptyView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.emptyView removeFromSuperview];
            self.addButton.hidden = shouldDisplayEmptyView;
        }];
    }
    _shouldDisplayEmptyView = shouldDisplayEmptyView;
}
@end
