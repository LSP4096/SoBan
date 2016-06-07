//
//  SOBuildingDetailViewController.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingDetailViewController.h"
#import "SOBuildingDetailDescriptionHeader.h"
#import "SOBuilding.h"
#import "SOBuildingDetailRoomFooter.h"
#import "SOBuildingDetailSurroundFooter.h"
#import "SOBuildingDetailItemsHeader.h"
#import "SOBuildingDetailSurroundHeader.h"
#import "SOBuildingDetailTrafficHeader.h"
#import "SOBuildingDetailRoomCell.h"
#import "SOBuildingDetailSurroundCell.h"
#import "SOBuildingDetailDescriptionCell.h"
#import "UITableView+RegisterNib.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "OMHTTPClient+Building.h"
#import "OMHUDManager.h"
#import "UIWebView+MakeCall.h"
#import "UITableView+HeaderFooterSection.h"
#import "SOBuildingDetailMapHeader.h"
#import "UIColor+OM.h"
#import "UIImage+Color.h"
#import "NSNotificationCenter+OM.h"
#import "SOBuildingScreenModel.h"
#import "UIStoryboard+SO.h"
#import "UITableView+FDTemplateLayoutSectionHeader.h"

@interface SOBuildingDetailViewController () <UITableViewDelegate, UITableViewDataSource, SOBuildingDetailRoomFooterDelegate, SOBuildingDetailDescriptionCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SOBuilding *building;
@property (strong, nonatomic) SOBuildingStation *buildingStation;
@property (nonatomic) BOOL expandLastCell;
@property (weak, nonatomic) IBOutlet UIButton *telButton;
@property (nonatomic) NSInteger roomDisplayCount;

@end


@implementation SOBuildingDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.telButton setBackgroundImage:[UIImage imageWithSolidColor:[UIColor at_deepSkyBlueColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];

    if (self.userInfo[@"title"]) {
        self.title = self.userInfo[@"title"];
    }

    [self.tableView registerCellNibWithClassIdentifiers:@[ [SOBuildingDetailRoomCell reuseIdentifier],
                                                           [SOBuildingDetailSurroundCell reuseIdentifier],
                                                           [SOBuildingDetailDescriptionCell reuseIdentifier] ]];
    [self.tableView registerHeaderFooterWithClassIdentifiers:@[ [SOBuildingDetailRoomFooter reuseIdentifier],
                                                                [SOBuildingDetailDescriptionHeader reuseIdentifier],
                                                                [SOBuildingDetailItemsHeader reuseIdentifier],
                                                                [SOBuildingDetailSurroundFooter reuseIdentifier],
                                                                [SOBuildingDetailTrafficHeader reuseIdentifier],
                                                                [SOBuildingDetailSurroundHeader reuseIdentifier],
                                                                [SOBuildingDetailMapHeader reuseIdentifier] ]];
    [self fetchBuildingDetail];

    [NSNotificationCenter registerNotificationWithObserver:self selector:@selector(loginSuccessWithNotification:) name:kUserLoginSuccess];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (void)loginSuccessWithNotification:(NSNotification *)notification
{
    [self fetchBuildingDetail];
}

- (void)fetchBuildingDetail
{
    [OMHUDManager showActivityIndicatorMessage:@"加载中..."];
    [[OMHTTPClient realClient] fetchBuildingDetailWithBuildingId:[self buildingId] screenModel:[self screenModel] completion:^(id resultObject, NSError *error) {
        [OMHUDManager dismiss];
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.building = resultObject;
//            NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"filterTarget" ascending:NO];
//            [self.building.rooms sortUsingDescriptors:@[sortDesc]];
            self.roomDisplayCount = self.building.rooms.count > 4?4:self.building.rooms.count;
            [self.tableView reloadData];
        }
    }];
}

- (void)fetchRooms
{
//    static NSInteger const pageSize = 10;
    /*
    SORoom *room = self.building.rooms.lastObject;
    [[OMHTTPClient sharedClient] fetchRoomsWithBuildingId:[self buildingId] lastObjectId:room.uniqueId limit:pageSize completion:^(NSArray *resultObject, NSError *error) {
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
        } else {
            if ([resultObject count] > 0) {
                NSInteger originCount = self.building.rooms.count;
                [self.building.rooms addObjectsFromArray:resultObject];
                
                NSMutableArray *indexPathArray = building[NSMutableArray new];
                for (NSInteger i = originCount; i < self.building.rooms.count; i++) {
                    [indexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:1]];
                }
                if (self.building.rooms.count < self.building.roomCount.integerValue) {
                    [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                    SOBuildingDetailRoomFooter *footer = (SOBuildingDetailRoomFooter *)[self.tableView footerViewForSection:1];
                    [footer configCellWithModel:self.building];
                } else {
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }
    }];
     */
    NSInteger originCount = self.roomDisplayCount;

    self.roomDisplayCount = self.building.rooms.count;//self.roomDisplayCount + pageSize > self.building.rooms.count ? self.building.rooms.count : self.roomDisplayCount + pageSize;

    NSMutableArray *indexPathArray = [NSMutableArray new];
    for (NSInteger i = originCount; i < self.roomDisplayCount; i++) {
        [indexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:1]];
    }
    if (self.roomDisplayCount == self.building.rooms.count) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        SOBuildingDetailRoomFooter *footer = (SOBuildingDetailRoomFooter *)[self.tableView footerViewForSection:1];
        [footer configCellWithText:[NSString stringWithFormat:@"查看全部%@套户型", @(self.building.rooms.count).stringValue]];
    }
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        SORoom *room = self.building.rooms[indexPath.row];
        if (room.expand) {
            return [tableView fd_heightForCellWithIdentifier:[SOBuildingDetailRoomCell reuseIdentifier] configuration:^(SOBuildingDetailRoomCell *cell) {
                [cell configCellWithModel:room];
            }];
        } else {
            return [SOBuildingDetailRoomCell height];
        }
    }
    if (indexPath.section == 4) {
        return [SOBuildingDetailSurroundCell height];
    }
    if (indexPath.section == 5) {
        return [tableView fd_heightForCellWithIdentifier:[SOBuildingDetailDescriptionCell reuseIdentifier] configuration:^(SOBuildingDetailDescriptionCell *cell) {
            [cell configCellWithText:self.building.buildingDescription expand:self.expandLastCell];
        }];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //    if (section == 1 && (self.building.roomCount.integerValue > self.building.rooms.count)) {
    if (section == 1 && (self.building.rooms.count > self.roomDisplayCount)) {
        return [SOBuildingDetailRoomFooter height];
    }
    if (section == 2) {
        return [SOBuildingDetailItemsHeader height];
    }
    if (section == 4) {
        return [SOBuildingDetailSurroundFooter height];
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [SOBuildingDetailDescriptionHeader height];
    }
    if (section == 1 && self.roomDisplayCount != 0) {
        return 10;
    }
    if (section == 2) {
        return [SOBuildingDetailMapHeader height];
    }
    if (section == 3) {
//        return [SOBuildingDetailTrafficHeader heightForBuilding:self.building];
        return [tableView fd_heightForSectionWithIdentifier:[SOBuildingDetailTrafficHeader reuseIdentifier] configuration:^(SOBuildingDetailTrafficHeader *section) {
            [section configCellWithBuilding:self.building];
        }];
    }
    if (section == 4) {
        return [SOBuildingDetailSurroundHeader height];
    }
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        SORoom *room = self.building.rooms[indexPath.row];
        room.expand = !room.expand;
        [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.building ? 6 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.building) {
        return 0;
    }
    if (section == 1) {
        //        return self.building.rooms.count;
        return self.roomDisplayCount;
    }
    if (section == 4) {
        return self.building.surround.count;
    }
    if (section == 5) {
        return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!self.building) {
        return nil;
    }
    //    if (section == 1 && (self.building.roomCount.integerValue > self.building.rooms.count)) {
    if (section == 1 && (self.building.rooms.count > self.roomDisplayCount)) {
        SOBuildingDetailRoomFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[SOBuildingDetailRoomFooter reuseIdentifier]];

        [footer configCellWithText:[NSString stringWithFormat:@"查看全部%@套户型", @(self.building.rooms.count).stringValue]];
        footer.delegate = self;
        return footer;
    }
    if (section == 2) {
        SOBuildingDetailItemsHeader *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[SOBuildingDetailItemsHeader reuseIdentifier]];
        [footer configHeaderWithModel:self.building.summaryInfo];
        return footer;
    }
    if (section == 4) {
        SOBuildingDetailSurroundFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[SOBuildingDetailSurroundFooter reuseIdentifier]];
        [footer configWithModel:self.building];
        return footer;
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
        [header configCellWithModel:self.building];
        return header;
    }
    if (section == 1 && self.roomDisplayCount != 0) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithHex:0xeeeeee];
        return view;
    }
    if (section == 2) {
        SOBuildingDetailMapHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[SOBuildingDetailMapHeader reuseIdentifier]];
        [header configWithAddress:self.building.location.address location:self.building.location.gpslocation title:self.building.name];
        return header;
    }
    if (section == 3) {
        SOBuildingDetailTrafficHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[SOBuildingDetailTrafficHeader reuseIdentifier]];
        [header configCellWithBuilding:self.building];
        return header;
    }
    if (section == 4) {
        SOBuildingDetailSurroundHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[SOBuildingDetailSurroundHeader reuseIdentifier]];
        return header;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        SOBuildingDetailRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:[SOBuildingDetailRoomCell reuseIdentifier]];
        [cell configCellWithModel:self.building.rooms[indexPath.row]];
        return cell;
    }
    if (indexPath.section == 4) {
        SOBuildingDetailSurroundCell *cell = [tableView dequeueReusableCellWithIdentifier:[SOBuildingDetailSurroundCell reuseIdentifier]];
        [cell configCellWithModel:self.building.surround[indexPath.row]];
        return cell;
    }
    if (indexPath.section == 5) {
        SOBuildingDetailDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:[SOBuildingDetailDescriptionCell reuseIdentifier]];
        cell.delegate = self;
        [cell configCellWithText:self.building.buildingDescription expand:self.expandLastCell];
        return cell;
    }
    return nil;
}

#pragma mark - Cell & HeaderFooter Delegate
- (void)buildingDetailRoomFooterLookMoreTapped
{
    [self fetchRooms];
}

- (void)buildingDetailDescriptionCellLookMoreTapped:(SOBuildingDetailDescriptionCell *)cell
{
    self.expandLastCell = !self.expandLastCell;
    //    [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationNone];
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

- (SOBuildingScreenModel *)screenModel
{
    return self.userInfo[@"screenModel"];
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
