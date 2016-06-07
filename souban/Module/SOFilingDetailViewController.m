//
//  SOFilingDetailViewController.m
//  souban
//
//  Created by 周国勇 on 12/24/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOFilingDetailViewController.h"
#import "SZTextView.h"
#import "SOFilingDetail.h"
#import "UIView+Layout.h"
#import "OMHTTPClient+Explore.h"
#import "OMUser.h"
#import "OMHUDManager.h"
#import <ActionSheetStringPicker.h>
#import "SOStepIndicator.h"
#import "Masonry.h"
#import "NSBundle+Nib.h"


@interface SOFilingDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet SZTextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) SOFilingDetail *filing;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) SOStepIndicator *stepIndicator;

@end


@implementation SOFilingDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.remarkTextView.textContainerInset = UIEdgeInsetsMake(0.01f, -5.0f, 0.01f, -5.0f);

    self.footerView.height = self.tableView.height - 64 - 31 - 60 * 3 - 115;
    self.tableView.tableFooterView = self.footerView;

    if ([self displayType] == SOFilingDetailViewControllerNormal && [self filingId]) {
        [OMHUDManager showActivityIndicatorMessage:@"加载中..."];
        [[OMHTTPClient realClient] fetchFilingDetailWithUserId:[OMUser user].uniqueId filingId:[self filingId] completion:^(id resultObject, NSError *error) {
            if (!error.hudMessage) {
                [OMHUDManager dismiss];
                self.filing = resultObject;
                [self.stepIndicator configViewWihtModel:self.filing];

                self.nameTextField.text = self.filing.name;
                self.genderLabel.text = self.filing.male?@"男":@"女";
                self.phoneTextField.text = self.filing.phoneNum;
                self.remarkTextView.text = self.filing.remark;
            }
        }];
    }
    [self setEditing:[self displayType] == SOFilingDetailViewControllerAdd];
    NSString *buttonTitle = [self displayType] == SOFilingDetailViewControllerAdd ? @"确认提交" : @"保存";
    [self.submitButton setTitle:buttonTitle forState:UIControlStateNormal];

    SOStepIndicator *indicator = [NSBundle loadNibFromMainBundleWithClass:[SOStepIndicator class]];
    [self.footerView addSubview:indicator];
    self.stepIndicator = indicator;
    __weak __typeof(&*self) weakSelf = self;
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.footerView.mas_left);
        make.right.equalTo(weakSelf.footerView.mas_right);
        make.top.equalTo(weakSelf.footerView.mas_top).with.offset(30);
        make.height.mas_equalTo(98);
    }];
    self.stepIndicator.hidden = [self displayType] == SOFilingDetailViewControllerAdd;
    if ([self displayType] == SOFilingDetailViewControllerAdd) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setEditing:(BOOL)editing
{
    [super setEditing:editing];
    self.tableView.editing = NO;
    [UIView animateWithDuration:0.2 animations:^{
        if ([self displayType] == SOFilingDetailViewControllerNormal) {
            self.submitButton.hidden = !editing;
            self.stepIndicator.hidden = editing;
        }
        
        self.nameTextField.userInteractionEnabled = editing;
        self.phoneTextField.userInteractionEnabled = editing;
        self.remarkTextView.userInteractionEnabled = editing;
        self.genderLabel.userInteractionEnabled = editing;
    }];
}

- (IBAction)genderLabelTapped:(id)sender
{
    [self.view endEditing:YES];
    NSArray *titles = @[ @"男", @"女" ];
    NSInteger selectedIndex = [titles indexOfObject:self.genderLabel.text];
    [ActionSheetStringPicker showPickerWithTitle:@"选择性别" rows:titles initialSelection:selectedIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.genderLabel.text = titles[selectedIndex];
    } cancelBlock:^(ActionSheetStringPicker *picker) {

    } origin:self.view];
}

- (IBAction)submitTapped:(id)sender
{
    NSNumber *userId = [OMUser user].uniqueId;
    self.filing.name = self.nameTextField.text;
    self.filing.male = [self.genderLabel.text isEqualToString:@"男"];
    self.filing.phoneNum = self.phoneTextField.text;
    self.filing.remark = self.remarkTextView.text;

    if (self.filing.name.length == 0) {
        [OMHUDManager showErrorWithStatus:@"姓名不能为空！"];
        return;
    }

    if (self.filing.phoneNum.length != 11) {
        [OMHUDManager showErrorWithStatus:@"请输入正确的手机号码！"];
        return;
    }

    if ([self displayType] == SOFilingDetailViewControllerNormal) {
        [[OMHTTPClient realClient] editFilings:self.filing withUserId:userId completion:^(id resultObject, NSError *error) {
            if (!error.hudMessage) {
                [OMHUDManager showSuccessWithStatus:@"修改成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        [[OMHTTPClient realClient] postFilings:self.filing withUserId:userId completion:^(id resultObject, NSError *error) {
            if (!error.hudMessage) {
                [OMHUDManager showSuccessWithStatus:@"添加成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (IBAction)editButtonTapped:(UIBarButtonItem *)sender
{
    [self setEditing:YES];
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Getter & Setter
- (SOFilingDetailViewControllerType)displayType
{
    return [self.userInfo[@"type"] integerValue];
}

- (NSNumber *)filingId
{
    return self.userInfo[@"filingId"];
}

- (SOFilingDetail *)filing
{
    if (!_filing) {
        _filing = [SOFilingDetail new];
    }
    return _filing;
}
@end
