//
//  JSIndexPath.h
//  souban
//
//  Created by 周国勇 on 11/6/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JSIndexTableType) {
    JSIndexTableTypeLeft = 0,
    JSIndexTableTypeRight = 1
};


@interface JSIndexPath : NSObject

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) JSIndexTableType tableType;
@property (nonatomic, assign) NSInteger leftRow;
@property (nonatomic, assign) NSInteger rightRow;

- (instancetype)initWithColumn:(NSInteger)column tableType:(JSIndexTableType)tableType leftRow:(NSInteger)leftRow rightRow:(NSInteger)rightRow;
+ (instancetype)indexPathWithCol:(NSInteger)col tableType:(JSIndexTableType)tableType leftRow:(NSInteger)leftRow rightRow:(NSInteger)rightRow;

@end
