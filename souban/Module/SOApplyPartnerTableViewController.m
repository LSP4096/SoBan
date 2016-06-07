//
//  SOApplyPartnerTableViewController.m
//  souban
//
//  Created by 周国勇 on 12/24/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOApplyPartnerTableViewController.h"
#import "UIColor+OM.h"
#import "OMHTTPClient+Explore.h"
#import "OMHUDManager.h"
#import "UIView+Layout.h"
#import "OMUser.h"
#import "SOCommonSlideView.h"
#import "SOWebViewController.h"
#import "UIStoryboard+SO.h"
#import "OMNavigationManager.h"
#import "CardIOPaymentViewController.h"
#import "CardIOCreditCardInfo.h"
#import "UIImage+Color.h"
#import "SOFilingsTableViewController.h"


@interface SOApplyPartnerTableViewController () <CardIOPaymentViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *agressButton;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@property (strong, nonatomic) CardIOPaymentViewController *cardController;

@end


@implementation SOApplyPartnerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.agressButton.layer.borderWidth = 1;
    self.agressButton.layer.borderColor = [UIColor colorWithHex:0x4f5e6e alpha:0.6].CGColor;

    [self.bankNameTextField addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.cardNumberTextField addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.nameLabel addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];

    self.footerView.height = self.tableView.height - 64 - 62 * 4 - 36 - 10;
    self.tableView.tableFooterView = self.footerView;

    self.phoneLabel.text = [OMUser user].phoneNum;

    UIImage *enableColor = [UIImage imageWithSolidColor:[UIColor at_deepSkyBlueColor] size:CGSizeMake(1, 1)];
    UIImage *disableColor = [UIImage imageWithSolidColor:[UIColor lightGrayColor] size:CGSizeMake(1, 1)];
    [self.applyButton setBackgroundImage:enableColor forState:UIControlStateNormal];
    [self.applyButton setBackgroundImage:disableColor forState:UIControlStateDisabled];

    [self checkApplyButton];
}

#pragma mark - TextField Delegate
- (void)textFieldValueDidChanged:(UITextField *)textField
{
    [self checkApplyButton];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - Private
- (void)checkApplyButton
{
    if (!self.agressButton.selected) {
        self.applyButton.enabled = NO;
        return;
    }

    if (self.bankNameTextField.text.length == 0) {
        self.applyButton.enabled = NO;
        return;
    }

    if (self.cardNumberTextField.text.length == 0) {
        self.applyButton.enabled = NO;
        return;
    }

    if (self.nameLabel.text.length == 0) {
        self.applyButton.enabled = NO;
        return;
    }
    self.applyButton.enabled = YES;
}

#pragma mark - Action
- (IBAction)checkTapped:(id)sender
{
    self.agressButton.selected = !self.agressButton.selected;
    [self checkApplyButton];
}

- (IBAction)cooperationTapped:(id)sender
{
    SOWebViewController *controller = [[UIStoryboard common] instantiateViewControllerWithIdentifier:[SOWebViewController storyboardIdentifier]];
    controller.userInfo = @{ @"url" : @"http://m.91souban.com/partners/policy",
                             @"title" : @"搜办众销合作协议" };

    [OMNavigationManager pushController:controller];
}

- (IBAction)cameraTapped:(id)sender
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.languageOrLocale = @"zh-Hans";
    scanViewController.hideCardIOLogo = YES;
    scanViewController.collectExpiry = NO;
    scanViewController.collectCVV = NO;
    scanViewController.scanExpiry = NO;
    self.cardController = scanViewController;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (IBAction)applyTapped:(id)sender
{
    if (self.applyButton.enabled == NO) {
        [OMHUDManager showInfoWithStatus:@"请填写完整的银行信息！"];
        return;
    }
    [OMHUDManager showActivityIndicatorMessage:@"提交中..."];
    [[OMHTTPClient realClient] applyPartnersWithName:self.nameLabel.text bankName:self.bankNameTextField.text cardNumber:self.cardNumberTextField.text completion:^(id resultObject, NSError *error) {
        if (!error.hudMessage) {
            [OMHUDManager showSuccessWithStatus:@"申请成功！"];
            OMUser *user = [OMUser user];
            user.partnerStatus = OMUserPartnerStatusConfirmed;
            [OMUser setUser:user];
            [self.navigationController popToRootViewControllerAnimated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SOFilingsTableViewController *controller = [[UIStoryboard explore] instantiateViewControllerWithIdentifier:[SOFilingsTableViewController storyboardIdentifier]];
                [OMNavigationManager pushController:controller];
            });
        }
    }];
}

#pragma mark - Card.io Delegate
/// This method will be called if the user cancels the scan. You MUST dismiss paymentViewController.
/// @param paymentViewController The active CardIOPaymentViewController.
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

/// This method will be called when there is a successful scan (or manual entry). You MUST dismiss paymentViewController.
/// @param cardInfo The results of the scan.
/// @param paymentViewController The active CardIOPaymentViewController.
- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    self.cardNumberTextField.text = cardInfo.cardNumber;
    [self checkApplyButton];
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
