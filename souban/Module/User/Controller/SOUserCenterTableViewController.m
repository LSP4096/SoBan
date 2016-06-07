//
//  SOUserCenterTableViewController.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOUserCenterTableViewController.h"
#import "ParallaxHeaderView.h"
#import "OMUser.h"
#import "OMAuthenticationViewController.h"
#import "OMNavigationManager.h"
#import "SOMyAccountViewController.h"
#import "SOMyOrderViewController.h"
#import "SOMyCollectionViewController.h"
#import "UIColor+ATColors.h"
#import "UIView+Layout.h"
#import "SOLoginButton.h"
#import "OMAboutTableViewViewController.h"


@interface SOUserCenterTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userMobileLabel;
@property (strong, nonatomic) SOLoginButton *loginButton;

@end


@implementation SOUserCenterTableViewController


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self SetupParallaxHeader];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.loginButton.hidden = [OMUser user] ? YES : NO;
    self.userMobileLabel.text = [OMUser user].phoneNum;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
//- (void)viewDidDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//}

#pragma mark - System
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - private Method

- (void)SetupParallaxHeader
{
    self.tableView.tableFooterView = [UIView new];
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[UIImage imageNamed:@"userCenter_bg.pdf"]
                                                                              avatar:[OMUser user].avatar
                                                                             forSize:CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.width / 375 * 230)];
    self.loginButton = [[SOLoginButton alloc] init];
    self.loginButton.frame = CGRectMake(0, 0, 80 * self.view.width / 375, 30 * self.view.width / 375);
    self.loginButton.center = CGPointMake(headerView.width / 2, headerView.height / 2 + 40 * self.view.width / 375 + 33);
    [self.loginButton addTarget:self action:@selector(toLogin) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.loginButton];
    [self.tableView setTableHeaderView:headerView];
}

- (void)toLogin
{
    OMAuthenticationViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:[OMAuthenticationViewController storyboardIdentifier]];
    [OMNavigationManager modalController:loginViewController];
}


#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}


#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 3) {
        if (![OMUser user]) {
            OMAuthenticationViewController *target = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:[OMAuthenticationViewController storyboardIdentifier]];
            [OMNavigationManager modalController:target];
        } else {
            if (indexPath.row == 0) {
                SOMyAccountViewController *target = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateViewControllerWithIdentifier:[SOMyAccountViewController storyboardIdentifier]];
                [OMNavigationManager pushController:target];
            } else if (indexPath.row == 1) {
                SOMyOrderViewController *target = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateViewControllerWithIdentifier:@"SOMyOrderViewController"];
                [OMNavigationManager pushController:target];
            } else if (indexPath.row == 2) {
                SOMyCollectionViewController *target = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateViewControllerWithIdentifier:@"SOMyCollectionViewController"];
                [OMNavigationManager pushController:target];
            }
        }
    }else{
        OMAboutTableViewViewController *aboutVC = [[OMAboutTableViewViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [OMNavigationManager pushController:aboutVC];
        self.hidesBottomBarWhenPushed = NO;
    }
}


@end
