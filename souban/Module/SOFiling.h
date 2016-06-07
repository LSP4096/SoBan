//
//  SOFiling.h
//  souban
//
//  Created by 周国勇 on 12/23/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseModel.h"

typedef NS_ENUM(NSUInteger, SOFilingStep) {
    SOFilingStepOne = 1,
    SOFilingStepTwo = 2,
    SOFilingStepThree = 3,
    SOFilingStepFour = 4,
    SOFilingStepFive = 5
};


@interface SOFiling : OMBaseModel

@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString<Optional> *remark;
@property (nonatomic) BOOL male; // ignored
@end
