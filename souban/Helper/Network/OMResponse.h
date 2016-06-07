//
//  BTResponse.h
//  BailkalTravel
//
//  Created by 周国勇 on 9/29/14.
//  Copyright (c) 2014 whalefin. All rights reserved.
//

#import "JSONModel.h"


@interface OMResponse : JSONModel

@property (strong, nonatomic) NSString *errMsg; // 错误信息
//@property (nonatomic) BOOL success;     // 接口调用是否成功
@property (nonatomic) NSInteger status;
@property (strong, nonatomic) id<Optional> data;

@end
