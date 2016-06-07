//
//  NSNotificationCenter+OM.h
//  OfficeManager
//
//  Created by 周国勇 on 8/17/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Shopping
/**
 *  OMShoppingTableViewController中选中、删除之后的通知
 */
extern NSString *const kShoppingDataChanged;

#pragma mark - Consigner
/**
 *  新增加了收货地址,userinfo:{consigner:OMConsignerInfo}
 */
extern NSString *const kPostConsignerSuccess;
/**
 *  更新了收货地址,userinfo:{consigner:OMConsignerInfo}
 */
extern NSString *const kUpdateConsignerSuccess;

#pragma mark - Auth
/**
 *  登录成功
 */
extern NSString *const kUserLoginSuccess;

/**
 *  注销
 */
extern NSString *const kUserLogoutSuccess;

/**
 *  token验证失败，通知退出
 */
extern NSString *const kAuthFailed;

#pragma mark - Order
/**
 *  支付成功,userinfo:{chargeId:NSString}
 */
extern NSString *const kPaySuccess;

/**
 *  支付失败
 */
extern NSString *const kPayFailed;

/**
 *  下订单成功,userinfo:{isShopping:BOOL,orderShops:NSArray<OMOrderShop>}是否从购物车进入
 */
extern NSString *const kOrderSubmitSuccess;

#pragma mark - User
/**
 *  消息数量更新，userinfo:{messageCount:NSNumber}
 */
extern NSString *const kUnreadMessageCountUpdated;

#pragma mark - Location
/**
 *  城市切换，userinfo:{city:SOCity}
 */
extern NSString *const kCityChanged;


@interface NSNotificationCenter (OM)

+ (void)registerNotificationWithObserver:(id)observer
                                selector:(SEL)selector
                                    name:(NSString *)name;

+ (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo;

@end
