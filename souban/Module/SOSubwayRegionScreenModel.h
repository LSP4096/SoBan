//
//  SOSubwayRegionScreenModel.h
//  souban
//
//  Created by JiaHao on 12/25/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "SOPOISummary.h"
#import "SOBuildingScreenModel.h"


@interface SOSubwayRegionScreenModel : JSONModel

@property (strong, nonatomic) SOPOILocation *center;
@property (strong, nonatomic) NSString *stationId;

@end
