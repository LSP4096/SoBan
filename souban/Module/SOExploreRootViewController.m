//
//  SOExplorerRootViewController.m
//  souban
//
//  Created by 周国勇 on 12/21/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOExploreRootViewController.h"
#import "SOExploreCollectionViewCell.h"
#import "UIView+Layout.h"
#import "SOWebViewController.h"
#import "UIStoryboard+SO.h"
#import "OMNavigationManager.h"
#import "OMUser.h"
#import "OMAuthenticationViewController.h"
#import "NSNotificationCenter+OM.h"
#import "OMHUDManager.h"
#import "SOFilingsTableViewController.h"
#import "SOCity.h"


@interface SOExploreRootViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end


@implementation SOExploreRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [NSNotificationCenter registerNotificationWithObserver:self selector:@selector(cityChanged:) name:kCityChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification 
- (void)cityChanged:(NSNotification *)notification {
    if (notification.userInfo[@"city"]) {
        [self.collectionView reloadData];
    }
}

#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SOExploreCollectionViewCell *cell = (SOExploreCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.type == SOServiceTypeIncubator) {
        [self performSegueWithIdentifier:@"pushToIncubator" sender:self];
    } else if (cell.type == SOServiceTypeEnterpriseGift) {
        [self performSegueWithIdentifier:@"pushToGifts" sender:self];
    } else if (cell.type == SOServiceTypePartner) {
        if (![OMUser user]) {
            [NSNotificationCenter postNotificationName:kAuthFailed userInfo:nil];
        } else {
            if ([OMUser user].partnerStatus == OMUserPartnerStatusNone) {
                SOWebViewController *controller = [[UIStoryboard common] instantiateViewControllerWithIdentifier:[SOWebViewController storyboardIdentifier]];
                controller.userInfo = @{ @"url" : @"http://m.91souban.com/partners/about?type=0",
                                         @"title" : @"搜办合伙人" };
                [OMNavigationManager pushController:controller];

            } else if ([OMUser user].partnerStatus == OMUserPartnerStatusReviewing) {
                [OMHUDManager showErrorWithStatus:@"您的申请已提交，请耐心等待审核通过！"];
            } else {
                [self performSegueWithIdentifier:@"pushToFilings" sender:self];
            }
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.width - 10) / 2, (self.view.width - 10) / 2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark - CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[SOCity city] supportExploreServices].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SOExploreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SOExploreCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    NSArray *names = @[ @"bg_explore_incubator", @"bg_explore_gifts", @"bg_explore_partner" ];
    SOServiceType type = [[[SOCity city] supportExploreServices][indexPath.row] integerValue];
    
    if (type == SOServiceTypeIncubator) {
        cell.itemImageView.image = [UIImage imageNamed:names[0]];
        cell.type = SOServiceTypeIncubator;
        return cell;
    } else if (type == SOServiceTypeEnterpriseGift) {
        cell.itemImageView.image = [UIImage imageNamed:names[1]];
        cell.type = SOServiceTypeEnterpriseGift;
        return cell;
    } else if (type == SOServiceTypePartner) {
        cell.itemImageView.image = [UIImage imageNamed:names[2]];
        cell.type = SOServiceTypePartner;
        return cell;
    }
    return nil;
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
