//
//  JSDropDownMenuHeaderCell.h
//  souban
//
//  Created by 周国勇 on 11/9/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseCollectionViewCell.h"


@interface JSDropDownMenuHeaderCell : OMBaseCollectionViewCell
@property (weak, nonatomic, readonly) IBOutlet UILabel *titleLabel;

- (void)configCellWithText:(NSString *)text displayLine:(BOOL)displayLine;

@end
