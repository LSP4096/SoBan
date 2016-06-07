//
//  SOFindHouseTableViewController.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOFindHouseTableViewController.h"
#import "OMHUDManager.h"
#import "SOFindBuildingRequestModel.h"
#import "OMHTTPClient+Service.h"
#import "OMHTTPClient+Building.h"
#import "SOArea.h"
#import "UIWebView+MakeCall.h"
#import "UIColor+PLNColors.h"


@interface SOFindHouseTableViewController () <UIPickerViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *bizCircleTextField;
@property (weak, nonatomic) IBOutlet UITextField *proportionTextField;
@property (weak, nonatomic) IBOutlet UITextField *rentTextField;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (strong, nonatomic) UIPickerView *areaPickView;
@property (strong, nonatomic) UIPickerView *bizPickView;


@property (strong, nonatomic) NSArray *areas;
@property (strong, nonatomic) NSArray *blocks;

@property (strong, nonatomic) SOArea *currentArea;
@property (strong, nonatomic) SOTag *currentBlock;

@end


@implementation SOFindHouseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"委托找楼";

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = view;

    [self setupPickView];
    [self setupTextFieldToolBar];
    [self getAreasData];
}


#pragma mark - Private Method

- (void)setupPickView
{
    self.areaPickView = [UIPickerView new];
    self.areaPickView.backgroundColor = [UIColor whiteColor];
    self.areaPickView.delegate = self;
    self.bizPickView = [UIPickerView new];
    self.bizPickView.backgroundColor = [UIColor whiteColor];
    self.bizPickView.delegate = self;
}
- (void)setupTextFieldToolBar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 35.0f)];
    toolbar.barStyle = UIBarStyleDefault;

    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneEdit)];
    [barButtonItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : SSColor(45, 116, 250) } forState:UIControlStateNormal];
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, barButtonItem, nil]];

    self.areaTextField.inputAccessoryView = toolbar;
    self.bizCircleTextField.inputAccessoryView = toolbar;
    self.proportionTextField.inputAccessoryView = toolbar;
    self.rentTextField.inputAccessoryView = toolbar;
    self.remarkTextView.inputAccessoryView = toolbar;
}
- (void)doneEdit
{
    [self.view endEditing:YES];
}

- (void)getAreasData
{
    [[OMHTTPClient realClient] fetchAreasListWithCompletion:^(NSArray *resultObject, NSError *error) {
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
        }else{
            self.areas = resultObject;
            for (SOArea *area in self.areas) {
                SOTag *tag = [SOTag new];
                tag.name = @"其他";
                [area.blocks addObject:tag];
            }
        }
    }];
}


- (IBAction)submit:(id)sender
{
    if (!self.areaTextField.text.length || !self.bizCircleTextField.text.length || !self.proportionTextField.text.length || !self.rentTextField.text.length) {
        [OMHUDManager showErrorWithStatus:@"请填写完整的信息"];
        return;
    }
    SOFindBuildingRequestModel *request = [SOFindBuildingRequestModel new];
    request.areaSize = @(self.proportionTextField.text.floatValue);
    request.price = @(self.rentTextField.text.floatValue);
    request.areaId = self.currentArea.uniqueId;
    request.remark = self.remarkTextView.text;
    request.block = self.currentBlock.uniqueId;

    [[OMHTTPClient realClient] findBuildingWithRequestModel:request completion:^(id resultObject, NSError *error) {
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
        }else{
            [OMHUDManager showSuccessWithStatus:@"提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (IBAction)makePhoneCall:(id)sender
{
    [UIWebView callWithString:@"4000571806"];
}

#pragma UIPickView Delegate &DataSource

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self.areas.count) {
        [OMHUDManager showInfoWithStatus:@"接口调用失败了"];
        return NO;
    }
    if ([textField isEqual:self.areaTextField]) {
        textField.inputView = self.areaPickView;
        SOArea *area = self.areas[[self.areaPickView selectedRowInComponent:0]];
        self.blocks = area.blocks;
        self.currentArea = area;

        if (self.blocks.count) {
            SOTag *biz = self.blocks[[self.bizPickView selectedRowInComponent:0]];
            self.bizCircleTextField.text = biz.name;
            self.currentBlock = biz;
        }

        self.areaTextField.text = area.name;
        [self.areaPickView reloadAllComponents];
    } else if ([textField isEqual:self.bizCircleTextField]) {
        if ([self.areaTextField.text isEqualToString:@""]) {
            [OMHUDManager showInfoWithStatus:@"请先选择区域"];
            return NO;
        }
        textField.inputView = self.bizPickView;
        SOTag *biz = self.blocks[[self.bizPickView selectedRowInComponent:0]];
        self.bizCircleTextField.text = biz.name;
        self.currentBlock = biz;

        [self.bizPickView reloadAllComponents];
        self.currentBlock = biz;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.areaTextField] || [textField isEqual:self.bizCircleTextField]) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.text = textView.text.length == 0 ? @"请在这里输入您更多的需求！" : @"";
    if (textView.text.length == 0) {
    } else {
        self.placeholderLabel.text = @"";
    }
}
#pragma UIPickView Delegate &DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.areaPickView]) {
        return self.areas.count;
    } else {
        return self.blocks.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.areaPickView]) {
        SOArea *area = self.areas[row];
        return area.name;
    } else {
        SOTag *block = self.blocks[row];
        return block.name;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.areaPickView]) {
        SOArea *area = self.areas[row];
        self.currentArea = area;
        self.blocks = area.blocks;
        [self.bizPickView reloadComponent:0];
        self.areaTextField.text = area.name;
        [self.bizPickView selectRow:0 inComponent:0 animated:YES];
        SOTag *tag = self.blocks[[self.bizPickView selectedRowInComponent:0]];
        self.bizCircleTextField.text = tag.name;
        self.currentBlock = tag;
    } else {
        SOTag *tag = self.blocks[row];
        self.bizCircleTextField.text = tag.name;
        self.currentBlock = tag;
    }
}


#pragma mark - Getter & Setter

- (NSArray *)areas
{
    if (_areas == nil) {
        _areas = [[NSArray alloc] init];
    }
    return _areas;
}

- (NSArray *)blocks
{
    if (_blocks == nil) {
        _blocks = [[NSArray alloc] init];
    }
    return _blocks;
}

@end
