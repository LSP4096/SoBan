//
//  SOFindBuildingRequestModel.h
//  souban
//
//  Created by JiaHao on 10/30/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <JSONModel.h>


@interface SOFindBuildingRequestModel : JSONModel

@property (strong, nonatomic) NSNumber *areaId;
@property (strong, nonatomic) NSNumber *areaSize;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *block;
@property (strong, nonatomic) NSString *remark;

@end
