//
//  SOExploreCollectionViewCell.h
//  souban
//
//  Created by 周国勇 on 12/24/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseCollectionViewCell.h"
#import "SOCity.h"


@interface SOExploreCollectionViewCell : OMBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (nonatomic) SOServiceType type;

@end
