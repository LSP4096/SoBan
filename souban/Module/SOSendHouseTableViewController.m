//
//  SOSendHouseTableViewController.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOSendHouseTableViewController.h"
#import "OMHUDManager.h"
#import "OMHTTPClient+Service.h"
#import "SOSendBuildingRequestModel.h"
#import "OMHTTPClient+Building.h"
#import "SOArea.h"
#import "UIWebView+MakeCall.h"
#import "UIColor+PLNColors.h"


@interface SOSendHouseTableViewController () <UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *bizCircleTextField;
@property (weak, nonatomic) IBOutlet UITextField *rentAreaTextField;
@property (weak, nonatomic) IBOutlet UITextField *rentPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *buildingNameTextField;

@property (strong, nonatomic) UIPickerView *areaPickView;
@property (strong, nonatomic) UIPickerView *bizPickView;

@property (strong, nonatomic) NSArray *areas;
@property (strong, nonatomic) NSArray *blocks;
@property (strong, nonatomic) SOArea *currentArea;
@property (strong, nonatomic) SOTag *currentBlock;


@end


@implementation SOSendHouseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"大楼投放";
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = view;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

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
    self.rentPriceTextField.inputAccessoryView = toolbar;
    self.rentAreaTextField.inputAccessoryView = toolbar;
    self.buildingNameTextField.inputAccessoryView = toolbar;
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
    if (!self.areaTextField.text.length || !self.bizCircleTextField.text.length || !self.rentAreaTextField.text.length || !self.rentPriceTextField.text.length || !self.buildingNameTextField.text.length) {
        [OMHUDManager showErrorWithStatus:@"请填写完整的信息"];
        return;
    }
    SOSendBuildingRequestModel *request = [SOSendBuildingRequestModel new];
    request.areaSize = @(self.rentAreaTextField.text.floatValue);
    request.name = self.buildingNameTextField.text;
    request.price = @(self.rentPriceTextField.text.floatValue);
    request.areaId = self.currentArea.uniqueId;
    request.block = self.currentBlock.uniqueId;
    request.address = [NSString stringWithFormat:@"%@%@", self.areaTextField.text, self.bizCircleTextField.text];
    request.block = self.currentBlock.uniqueId;
    [[OMHTTPClient realClient] sendBuildingWithRequestModel:request completion:^(id resultObject, NSError *error) {
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
        }else{
            [OMHUDManager showSuccessWithStatus:@"感谢您的提交，我们的专属客服经理将会联系到您！"];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.areaTextField] || [textField isEqual:self.bizCircleTextField]) {
        return NO;
    }
    return YES;
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
        SOTag *biz = self.blocks[[self.bizPickView selectedRowInComponent:0]];
        self.bizCircleTextField.text = biz.name;
        textField.inputView = self.bizPickView;
        self.currentBlock = biz;
        [self.bizPickView reloadAllComponents];
        self.currentBlock = biz;
    }
    return YES;
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
        SOTag *tag = self.blocks[[self.bizPickView selectedRowInComponent:0]];
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
