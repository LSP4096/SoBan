//
//  SOBuildingAnnotation.h
//  souban
//
//  Created by JiaHao on 11/19/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SOBuildingAnnotation : UIView


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *buildingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildingNameLabel;

@end
