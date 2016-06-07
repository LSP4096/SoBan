//
//  SOLaunchImage.h
//  souban
//
//  Created by 周国勇 on 1/11/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SOLaunchOptions : JSONModel

@property (strong, nonatomic) NSString *url;
@property (nonatomic) NSInteger updateTime;
@property (strong, nonatomic) NSString<Optional> *updateMessage;
@property (nonatomic) BOOL forceUpdate;

@end
