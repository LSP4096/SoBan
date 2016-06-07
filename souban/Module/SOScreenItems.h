//
//  SOScreenItems.h
//  souban
//
//  Created by 周国勇 on 10/29/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <JSONModel.h>
#import "SOArea.h"

static NSInteger const kMaxRangeValue = 1000000;

@protocol SORangeItem <NSObject>

@end


@interface SORangeItem : JSONModel

@property (strong, nonatomic) NSNumber *maxValue;
@property (strong, nonatomic) NSNumber *minValue;
@property (strong, nonatomic) NSString<Optional> *priceUnit;

@end


@interface SOScreenItems : JSONModel

@property (strong, nonatomic) NSArray<SOArea> *areas;
@property (strong, nonatomic) NSArray<SORangeItem> *areaSize;
@property (strong, nonatomic) NSArray<SORangeItem> *price;
@property (strong, nonatomic) NSArray<SOTagContainer> *tags;

@end
