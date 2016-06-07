//
//  SOCityChooseTableViewController.m
//  souban
//
//  Created by 周国勇 on 1/5/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "SOCityChooseTableViewController.h"
#import "SOCityChooseCell.h"
#import "SOCity.h"
#import "NSNotificationCenter+OM.h"
#import "SORefreshHeader.h"
#import "OMHTTPClient+Building.h"
#import "OMHUDManager.h"
#import <FCCurrentLocationGeocoder.h>

@interface SOCityChooseTableViewController ()

@property (strong, nonatomic) NSMutableArray *citys;
@property (strong, nonatomic) NSString *locationCity;

@end

@implementation SOCityChooseTableViewController

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[FCCurrentLocationGeocoder sharedGeocoder] cancelGeocode];
}

#pragma mark - Private
- (void)refreshData {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [[OMHTTPClient realClient] fetchCitysWithCompletion:^(id resultObject, NSError *error) {
        dispatch_group_leave(group);
        
        if (!error.hudMessage) {
            [self.citys removeAllObjects];
            [self.citys addObjectsFromArray:resultObject];
            [SOCity setSupportCitys:self.citys];
        }
    }];
    
    FCCurrentLocationGeocoder *geoCoder = [FCCurrentLocationGeocoder sharedGeocoder];
    geoCoder.canUseIPAddressAsFallback = NO;
    if (![geoCoder canGeocode]) {
        [OMHUDManager showErrorWithStatus:@"定位失败，请检查设置中的定位设置！"];
    } else {
        if ([geoCoder isGeocoding]) {
            [geoCoder cancelGeocode];
        }
        dispatch_group_enter(group);

        [geoCoder reverseGeocode:^(BOOL success) {
            dispatch_group_leave(group);
            self.locationCity = geoCoder.locationCity;

        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView.refreshHeader endRefreshing];
        [self.tableView reloadData];
    });
}

- (NSInteger)locationCityIndex {
    NSInteger index = NSNotFound;
    for (SOCity *city in self.citys) {
        if ([city.name isEqualToString:self.locationCity] || [[self.locationCity substringToIndex:self.locationCity.length-1] isEqualToString:city.name]) {
            index = [self.citys indexOfObject:city];
            break;
        }
    }
    return index;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && self.locationCity) {
        if ([self locationCityIndex] != NSNotFound) {
            [SOCity setCity:self.citys[[self locationCityIndex]]];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [SOCity setCity:self.citys[indexPath.row]];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.locationCity?2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.locationCity && section == 0) {
        return 1;
    }
    return self.citys.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (self.locationCity && section==0)?@"定位城市":@"可选城市";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SOCityChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:[SOCityChooseCell reuseIdentifier]];
    
    if (self.locationCity && indexPath.section == 0) {

        cell.cityNameLabel.text = [self locationCityIndex] != NSNotFound?self.locationCity:[NSString stringWithFormat:@"%@（暂不支持）", self.locationCity];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    } else {
        SOCity *city = self.citys[indexPath.row];
        cell.cityNameLabel.text = city.name;
        cell.accessoryType = [city.uniqueId isEqual:[SOCity currentCityId]]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    }

    return cell;
}

#pragma mark - Action
- (IBAction)closeTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter
- (NSMutableArray *)citys {
    if (!_citys) {
        _citys = [NSMutableArray new];
    }
    return _citys;
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
