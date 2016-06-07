//
//  SOPOISummary.h
//  souban
//
//  Created by JiaHao on 11/23/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "SOBuildingPOI.h"


@protocol SOBuildingPOI <NSObject>

@end


@interface SOPOISummary : JSONModel

@property (strong, nonatomic) NSString *centerLocation;
@property (strong, nonatomic) NSNumber *level;
@property (strong, nonatomic) NSArray<SOBuildingPOI> *poiList;

@end
