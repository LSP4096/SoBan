//
//  SOGiftsTableViewController.m
//  souban
//
//  Created by 周国勇 on 1/4/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "SOGiftsTableViewController.h"
#import "SORefreshHeader.h"
#import "SOGiftsTableViewCell.h"
#import "SOGiftsDetailViewController.h"
#import "UIStoryboard+SO.h"
#import "SOGift.h"
#import "OMNavigationManager.h"
#import "OMHTTPClient+Explore.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface SOGiftsTableViewController ()

@property (strong, nonatomic) NSMutableArray *gifts;

@end

@implementation SOGiftsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SORefreshHeader *header = [SORefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.refreshHeader = header;
    [self.tableView.refreshHeader beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (void)refreshData {
    [[OMHTTPClient realClient] fetchGiftsWithCompletion:^(id resultObject, NSError *error) {
        [self.tableView.refreshHeader endRefreshing];
        if (!error.hudMessage) {
            [self.gifts removeAllObjects];
            [self.gifts addObjectsFromArray:resultObject];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SOGift *gift = self.gifts[indexPath.row];
    SOGiftsDetailViewController *controller = [[UIStoryboard explore] instantiateViewControllerWithIdentifier:[SOGiftsDetailViewController storyboardIdentifier]];
    controller.userInfo = @{@"url":[NSString stringWithFormat:@"http://m.91souban.com/enterprise/gift?id=%@", gift.uniqueId],
                            @"title":gift.name};
    [OMNavigationManager pushController:controller];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:[SOGiftsTableViewCell reuseIdentifier] configuration:^(SOGiftsTableViewCell *cell) {
        [cell configCellWithModel:self.gifts[indexPath.row]];
    }];
}

#pragma mark - TableView DataSource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gifts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SOGiftsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SOGiftsTableViewCell reuseIdentifier]];
    [cell configCellWithModel:self.gifts[indexPath.row]];
    return cell;
}

#pragma mark - Getter
- (NSMutableArray *)gifts {
    if (!_gifts) {
        _gifts = [NSMutableArray new];
    }
    return _gifts;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
