//
//  SOCollectBuildingSummary.h
//  souban
//
//  Created by JiaHao on 11/2/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "JSONModel.h"
#import "SOCollectBuilding.h"

@protocol SOCollectBuilding <NSObject>
@end


@interface SOCollectBuildingSummary : JSONModel

@property (strong, nonatomic) NSNumber *totalNumber;
@property (strong, nonatomic) NSMutableArray<SOCollectBuilding> *list;

@end
