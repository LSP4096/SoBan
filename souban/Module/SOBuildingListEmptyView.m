

//
//  SOBuildingListEmptyView.m
//  souban
//
//  Created by 周国勇 on 11/11/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingListEmptyView.h"
#import "OMNavigationManager.h"
#import "SOFindHouseTableViewController.h"
#import "SOSubmitRoundButton.h"


@interface SOBuildingListEmptyView ()
@property (weak, nonatomic) IBOutlet SOSubmitRoundButton *button;
@property (copy, nonatomic) void (^buttonAction)();
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end


@implementation SOBuildingListEmptyView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)findHouseButtonTapped:(id)sender
{
    if (self.buttonAction) {
        self.buttonAction();
    } else {
        [OMNavigationManager pushControllerWithStoryboardName:kStoryboardService identifier:[SOFindHouseTableViewController storyboardIdentifier] userInfo:nil];
    }
}

- (void)configWithDescription:(NSString *)description buttonTitle:(NSString *)title buttonAction:(void (^)())buttonAction
{
    [self.button setTitle:title forState:UIControlStateNormal];
    self.descriptionLabel.text = description;
    self.buttonAction = buttonAction;
}
@end
