//
//  JSDropDownMenuTableViewCell.h
//  JSDropDownMenuDemo
//
//  Created by 周国勇 on 10/28/15.
//  Copyright © 2015 jsfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSIndexPath.h"


@interface JSDropDownMenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

- (void)configCellWithText:(NSString *)text selected:(BOOL)selected showCheckImage:(BOOL)showCheck tableType:(JSIndexTableType)tableType showSeparatorLine:(BOOL)showSeparator;
@end
