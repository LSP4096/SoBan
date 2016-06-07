//
//  OMUser.h
//  OfficeManager
//
//  Created by 周国勇 on 8/20/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMBaseModel.h"

typedef NS_ENUM(NSUInteger, OMUserPartnerStatus) {
    OMUserPartnerStatusNone = 1,
    OMUserPartnerStatusReviewing = 2,
    OMUserPartnerStatusConfirmed = 3,
};


@interface OMUser : OMBaseModel

@property (strong, nonatomic) NSString *phoneNum;
@property (strong, nonatomic) NSNumber<Optional> *device;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString<Optional> *avatar;
@property (nonatomic) OMUserPartnerStatus partnerStatus;

+ (void)setUser:(OMUser *)aUser;
+ (instancetype)user;

@end
