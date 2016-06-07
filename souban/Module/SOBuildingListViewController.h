//
//  SOBuildingListViewController.h
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseViewController.h"
#import "SODropDownMenuManager.h"

/**
 *  写字楼列表,userinfo:{hideScreenBar:BOOL,keyword:NSString}
 */
@interface SOBuildingListViewController : OMBaseViewController
@property (strong, nonatomic) SODropDownMenuManager *menuManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
