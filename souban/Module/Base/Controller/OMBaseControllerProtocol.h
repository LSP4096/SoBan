//
//  OMBaseControllerProtocol.h
//  OfficeManager
//
//  Created by 周国勇 on 8/20/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  控制器消失时需要执行的一些逻辑
 *
 *  @param callbackInfo 控制器回传给栈底『上一层控制器』的数据
 *
 *  @return YES则可执行dismiss/pop逻辑；NO则表示dismiss出错，需要重新判断数据
 */
typedef BOOL (^dismissCallback)(NSDictionary *callbackInfo);
@protocol OMBaseControllerProtocol <NSObject>
/**
 *  默认的控制器之间的传值方式
 *
 *  @param userInfo 在push/present一个控制器时，需要传递的参数
 */
- (void)setUserInfo:(NSDictionary *)userInfo;
- (NSDictionary *)userInfo;

/**
 *  设置在视图控制器将消失时，执行的回调
 *
 *  @param callback
 */
- (void)setDismissCallback:(dismissCallback)callback;
- (dismissCallback)dismissCallback;

@optional
+ (NSString *)storyboardIdentifier;

@end
