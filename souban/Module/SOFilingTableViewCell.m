//
//  SOFilingTableViewCell.m
//  souban
//
//  Created by 周国勇 on 12/24/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOFilingTableViewCell.h"
#import "SOFiling.h"


@interface SOFilingTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end


@implementation SOFilingTableViewCell

- (void)configCellWithModel:(SOFiling *)filing
{
    self.nameLabel.text = filing.name;
    self.genderLabel.text = filing.male ? @"先生" : @"女士";
    self.remarkLabel.text = filing.remark;
}

@end
