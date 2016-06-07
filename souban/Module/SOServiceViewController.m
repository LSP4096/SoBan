//
//  SOServiceViewController.m
//  souban
//
//  Created by JiaHao on 10/29/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOServiceViewController.h"
#import "UIWebView+MakeCall.h"
#import "OMUser.h"
#import "OMAuthenticationViewController.h"
#import "OMNavigationManager.h"
#import "SOSendHouseTableViewController.h"
#import "SOFindHouseTableViewController.h"
#import "SOPledgeLoadTableViewController.h"
#import "SOCity.h"
#import "UIView+FDCollapsibleConstraints.h"
#import "NSNotificationCenter+OM.h"
#import "SOFinancialViewController.h"


@interface SOServiceViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *roomRecommandView;
@property (weak, nonatomic) IBOutlet UIView *roomSupplyView;
@property (weak, nonatomic) IBOutlet UIView *mortgageView;

@end


@implementation SOServiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [NSNotificationCenter registerNotificationWithObserver:self selector:@selector(cityChanged:) name:kCityChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification
- (void)cityChanged:(NSNotification *)notification {
    if (notification.userInfo[@"city"]) {
        [self refreshView];
    }
}

#pragma mark - Private
- (void)refreshView {
    SOCity *city = [SOCity city];
    self.roomRecommandView.fd_collapsed = ![city supportForService:SOServiceTypeRoomDemand];
    self.roomSupplyView.fd_collapsed = ![city supportForService:SOServiceTypeRoomSupply];
    self.mortgageView.fd_collapsed = ![city supportForService:SOServiceTypeMortgage];
    self.roomRecommandView.hidden = ![city supportForService:SOServiceTypeRoomDemand];
    self.roomSupplyView.hidden = ![city supportForService:SOServiceTypeRoomSupply];
    self.mortgageView.hidden = ![city supportForService:SOServiceTypeMortgage];
}

#pragma mark - Action

- (IBAction)makePhoneCall:(id)sender
{
    [UIWebView callWithString:@"4000571806"];
}

- (IBAction)sendBuilding:(id)sender
{
//    if (![OMUser user]) {
//        OMAuthenticationViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:[OMAuthenticationViewController storyboardIdentifier]];
//        [OMNavigationManager modalController:loginViewController];
//    } else {
        SOSendHouseTableViewController *target = [[UIStoryboard storyboardWithName:@"Service" bundle:nil] instantiateViewControllerWithIdentifier:[SOSendHouseTableViewController storyboardIdentifier]];
        [OMNavigationManager pushController:target];
//    }
}
- (IBAction)findBuilding:(id)sender
{
    if (![OMUser user]) {
        OMAuthenticationViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:[OMAuthenticationViewController storyboardIdentifier]];
        [OMNavigationManager modalController:loginViewController];
    } else {
        SOFindHouseTableViewController *target = [[UIStoryboard storyboardWithName:@"Service" bundle:nil] instantiateViewControllerWithIdentifier:[SOFindHouseTableViewController storyboardIdentifier]];
        [OMNavigationManager pushController:target];
    }
}

- (IBAction)pledgeLoan:(id)sender
{
//    if (![OMUser user]) {
//        OMAuthenticationViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:[OMAuthenticationViewController storyboardIdentifier]];
//        [OMNavigationManager modalController:loginViewController];
//    } else {
    
        SOFinancialViewController *target = [[UIStoryboard storyboardWithName:kStoryboardService bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SOFinancialViewController class])];
        
        [OMNavigationManager pushController:target];
//    }
}

@end
