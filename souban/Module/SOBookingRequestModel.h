//
//  SOBookingRequestModel.h
//  souban
//
//  Created by JiaHao on 10/30/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseModel.h"


@interface SOBookingRequestModel : JSONModel

@property (strong, nonatomic) NSNumber *roomId;
@property (strong, nonatomic) NSString *alternativeTime;
@property (strong, nonatomic) NSString *preferredTime;


@end
