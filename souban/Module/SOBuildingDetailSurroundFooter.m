//
//  SOBuildingDetailSurroundFooter.m
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingDetailSurroundFooter.h"
#import "UIColor+OM.h"
#import "OMNavigationManager.h"
#import "SOWebViewController.h"
#import "SOBuilding.h"
#import "OMHTTPClient.h"
#import "SOSurroundMapViewController.h"


@interface SOBuildingDetailSurroundFooter ()

@property (weak, nonatomic) IBOutlet UIButton *lookSurroundButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) SOBuilding *building;

@end


@implementation SOBuildingDetailSurroundFooter
@dynamic contentView;

+ (CGFloat)height
{
    return 72;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.lookSurroundButton.layer.borderColor = [UIColor at_deepSkyBlueColor].CGColor;
    self.lookSurroundButton.layer.borderWidth = 1;
}

- (void)configWithModel:(SOBuilding *)building
{
    self.building = building;
}

- (IBAction)surroundButtonTapped:(id)sender
{
    [OMNavigationManager pushControllerWithStoryboardName:kStoryboardMap identifier:[SOSurroundMapViewController storyboardIdentifier] userInfo:@{ @"gpsLocation" : self.building.location.gpslocation,
                                                                                                                                                   @"title" : self.building.name }];
}

@end
