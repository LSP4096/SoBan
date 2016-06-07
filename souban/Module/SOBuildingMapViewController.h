//
//  SOBuildingMapViewController.h
//  souban
//
//  Created by JiaHao on 11/18/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseViewController.h"
#import "SOScreenItems.h"
#import "SODropDownMenuManager.h"
#import "SOBuildingListViewController.h"

@protocol SOBuildingMapViewControllerDelegate <NSObject>

- (void)flipButtonTapped;

@end


@interface SOBuildingMapViewController : OMBaseViewController

@property (strong, nonatomic) SOScreenItems *screenItems;
@property (strong, nonatomic) SODropDownMenuManager *menuManager;
@property (nonatomic) BOOL shouldLoad;
@property (weak, nonatomic) id<SOBuildingMapViewControllerDelegate> delegate;
@property (strong, nonatomic, readonly) NSString *keyword;


- (void)fetchDataWithKeyword:(NSString *)keyword;
@end
