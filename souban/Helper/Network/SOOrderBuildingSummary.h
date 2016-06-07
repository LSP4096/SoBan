//
//  SOOrderBuildingSummary.h
//  souban
//
//  Created by JiaHao on 11/2/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "JSONModel.h"
#import "SOOrderBuilding.h"

@protocol SOOrderBuilding <NSObject>
@end


@interface SOOrderBuildingSummary : JSONModel

@property (strong, nonatomic) NSNumber *totalNumber;
@property (strong, nonatomic) NSMutableArray<SOOrderBuilding> *list;

@end
