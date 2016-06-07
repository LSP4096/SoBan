//
//  SOBuildingSummary.h
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseModel.h"
#import "SOLocation.h"


@interface SOBuildingSummary : OMBaseModel

@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSString *priceUnit;
@property (strong, nonatomic) NSNumber *roomCount;
@property (strong, nonatomic) NSNumber<Optional> *filterCount;
@property (strong, nonatomic) NSArray<SOTag, Optional> *tags;
@property (strong, nonatomic) SOLocation *location;

@end
