//
//  SOFilingTableViewCell.h
//  souban
//
//  Created by 周国勇 on 12/24/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewCell.h"

@class SOFiling;


@interface SOFilingTableViewCell : OMBaseTableViewCell

- (void)configCellWithModel:(SOFiling *)filing;

@end
