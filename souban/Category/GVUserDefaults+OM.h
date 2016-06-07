//
//  GVUserDefaults+OM.h
//  OfficeManager
//
//  Created by 周国勇 on 8/20/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "GVUserDefaults.h"


@interface GVUserDefaults (OM)

@property (nonatomic, getter=isLogin) BOOL login;
@property (nonatomic, strong) NSString *userString;// 登录后的user对象
@property (strong, nonatomic) NSString *cityString;// 当前的城市对象
@property (nonatomic, strong) NSString *baiduClientId;
@property (strong, nonatomic) NSString *currentChargeId;
@property (strong, nonatomic) NSString *lastNotifiDate; // 最后一次提示新增房源的时间

@end
