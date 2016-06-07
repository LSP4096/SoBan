//
//  SOFilingDetailViewController.h
//  souban
//
//  Created by 周国勇 on 12/24/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewController.h"

typedef NS_ENUM(NSUInteger, SOFilingDetailViewControllerType) {
    SOFilingDetailViewControllerAdd = 0,
    SOFilingDetailViewControllerNormal = 2
};

/**
 *  userinfo:{type:NSIntege, filingId:<NSString, Optional>}
 */
@interface SOFilingDetailViewController : OMBaseTableViewController

@end
