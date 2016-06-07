//
//  SOBuildingStationDetailViewController.m
//  souban
//
//  Created by 周国勇 on 11/11/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingStationDetailViewController.h"
#import "UICollectionView+RegisterNib.h"
#import "UITableView+RegisterNib.h"
#import "SOBuildingDetailDescriptionCell.h"
#import "SOBuildingDetailStationCell.h"
#import "SOBuildingDetailDescriptionHeader.h"
#import "SOBuildingDetailTrafficHeader.h"
#import "SOBuildingDetailMapHeader.h"
#import "SOBuildingDetailItemsHeader.h"
#import "SOBuildingDetailCollectionHeader.h"
#import "OMHTTPClient+Building.h"
#import "OMHUDManager.h"
#import "SOBuildingStation.h"
#import "UITableView+FDTemplateLayoutSectionHeader.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "UIColor+OM.h"
#import "UIWebView+MakeCall.h"
#import "UIImage+Color.h"


@interface SOBuildingStationDetailViewController () <UITableViewDelegate, UITableViewDataSource, SOBuildingDetailDescriptionCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SOBuildingStation *building;
@property (nonatomic) BOOL expandLastCell;
@property (weak, nonatomic) IBOutlet UIButton *telButton;

@end


@implementation SOBuildingStationDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.telButton setBackgroundImage:[UIImage imageWithSolidColor:[UIColor at_deepSkyBlueColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];

    [self.tableView registerCellNibWithClassIdentifiers:@[ [SOBuildingDetailStationCell reuseIdentifier],
                                                           [SOBuildingDetailDescriptionCell reuseIdentifier] ]];

    [self.tableView registerHeaderFooterWithClassIdentifiers:@[ [SOBuildingDetailDescriptionHeader reuseIdentifier],
                                                                [SOBuildingDetailItemsHeader reuseIdentifier],
                                                                [SOBuildingDetailTrafficHeader reuseIdentifier],
                                                                [SOBuildingDetailMapHeader reuseIdentifier],
                                                                [SOBuildingDetailCollectionHeader reuseIdentifier] ]];

    [self fetchBuildingDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (void)fetchBuildingDetail
{
    [OMHUDManager showActivityIndicatorMessage:@"加载中..."];
    [[OMHTTPClient realClient] fetchStationBuildingDetailWithBuildingId:[self buildingId] completion:^(id resultObject, NSError *error) {
        [OMHUDManager dismiss];
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.building = resultObject;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        //        return [SOBuildingDetailStationCell height];
        return [tableView fd_heightForCellWithIdentifier:[SOBuildingDetailStationCell reuseIdentifier] configuration:^(SOBuildingDetailStationCell *cell) {
            [cell configCellWithModel:self.building];
        }];
    }
    if (indexPath.section == 7) {
        return [tableView fd_heightForCellWithIdentifier:[SOBuildingDetailDescriptionCell reuseIdentifier] configuration:^(SOBuildingDetailDescriptionCell *cell) {
            [cell configCellWithText:self.building.incubatorDescription expand:self.expandLastCell];
        }];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 10;
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [SOBuildingDetailDescriptionHeader height];
    }
    if (section == 1) {
        return 10;
    }
    if (section == 2) {
        return [SOBuildingDetailItemsHeader height];
    }
    if (section == 3 || section == 4) {
        NSInteger count = section == 3 ? self.building.complements.count : self.building.services.count;
        return [SOBuildingDetailCollectionHeader heightForItemsCount:count];
    }
    if (section == 5) {
        return [SOBuildingDetailMapHeader height];
    }
    if (section == 6) {
//        return [SOBuildingDetailTrafficHeader stationHeightForBuilding:self.building];
        return [tableView fd_heightForSectionWithIdentifier:[SOBuildingDetailTrafficHeader reuseIdentifier] configuration:^(SOBuildingDetailTrafficHeader *section) {
            [section configCellWithStation:self.building];
        }];
    }
    return 0.1f;
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.building ? 8 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.building) {
        return 0;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 7) {
        return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithHex:0xeeeeee];
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.building) {
        return nil;
    }
    if (section == 0) {
        SOBuildingDetailDescriptionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[SOBuildingDetailDescriptionHeader reuseIdentifier]];
        [header configCellWithStationModel:self.building];
        return header;
    }
    if (section == 1) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithHex:0xeeeeee];
        return view;
    }
    if (section == 2) {
        SOBuildingDetailItemsHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[SOBuildingDetailItemsHeader reuseIdentifier]];
        [header configHeaderWithModel:self.building.incubatorInfo];
        return header;
    }
    if (section == 3 || section == 4) {
        SOBuildingDetailCollectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[SOBuildingDetailCollectionHeader reuseIdentifier]];
        NSString *title = section == 3 ? @"空间配套" : @"企业服务";
        NSArray *items = section == 3 ? self.building.complements : self.building.services;
        [header configWihtTitle:title array:items];
        return items.count == 0 ? nil : header;
    }
    if (section == 5) {
        SOBuildingDetailMapHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[SOBuildingDetailMapHeader reuseIdentifier]];
        [header configWithAddress:self.building.location.address location:self.building.location.gpslocation title:self.building.name];
        return header;
    }
    if (section == 6) {
        SOBuildingDetailTrafficHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[SOBuildingDetailTrafficHeader reuseIdentifier]];
        [header configCellWithStation:self.building];
        return self.building.traffic.count != 0 ? header : nil;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        SOBuildingDetailStationCell *cell = [tableView dequeueReusableCellWithIdentifier:[SOBuildingDetailStationCell reuseIdentifier]];
        [cell configCellWithModel:self.building];
        return cell;
    }
    if (indexPath.section == 7) {
        SOBuildingDetailDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:[SOBuildingDetailDescriptionCell reuseIdentifier]];
        cell.delegate = self;
        [cell configCellWithText:self.building.incubatorDescription expand:self.expandLastCell];
        return cell;
    }
    return nil;
}

#pragma mark - Cell & HeaderFooter Delegate

- (void)buildingDetailDescriptionCellLookMoreTapped:(SOBuildingDetailDescriptionCell *)cell
{
    self.expandLastCell = !self.expandLastCell;
    //    [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
    // 禁用动画，处理这里还会有动画的傻逼问题
    [UIView setAnimationsEnabled:NO];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:7] withRowAnimation:UITableViewRowAnimationNone];
    [UIView setAnimationsEnabled:YES];
}

#pragma mark - Action
- (IBAction)telephoneTapped:(UIButton *)sender
{
    [UIWebView callWithString:@"4000571806"];
}

#pragma mark - Getter & Setter
- (NSNumber *)buildingId
{
    return self.userInfo[@"buildingId"];
}
@end
