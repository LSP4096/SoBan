//
//  SOLoadRequestModel.h
//  souban
//
//  Created by JiaHao on 12/29/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface SOLoadRequestModel : JSONModel


@property (strong, nonatomic) NSString *buildingName;
@property (strong, nonatomic) NSString *leaseState;
@property (strong, nonatomic) NSString *phoneNum;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *areaSize;


@end
