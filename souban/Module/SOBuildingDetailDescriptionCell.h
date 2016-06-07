//
//  SOBuildingDetailDescriptionCell.h
//  souban
//
//  Created by 周国勇 on 11/2/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewCell.h"

@class SOBuildingDetailDescriptionCell;
@protocol SOBuildingDetailDescriptionCellDelegate <NSObject>

- (void)buildingDetailDescriptionCellLookMoreTapped:(SOBuildingDetailDescriptionCell *)cell;

@end


@interface SOBuildingDetailDescriptionCell : OMBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageView;
@property (weak, nonatomic) id<SOBuildingDetailDescriptionCellDelegate> delegate;

- (void)configCellWithText:(NSString *)text expand:(BOOL)expand;

@end
