//
//  SOLocation.h
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseModel.h"
#import "SOTag.h"

@protocol SOLocation <NSObject>

@end


@interface SOLocation : JSONModel

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *gpslocation;
//@property (strong, nonatomic) NSNumber *latitude;
//@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) SOTag *area;
@property (strong, nonatomic) SOTag *block;

@end
