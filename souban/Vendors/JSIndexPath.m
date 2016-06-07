//
//  JSIndexPath.m
//  souban
//
//  Created by 周国勇 on 11/6/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "JSIndexPath.h"


@implementation JSIndexPath

- (instancetype)initWithColumn:(NSInteger)column tableType:(JSIndexTableType)tableType leftRow:(NSInteger)leftRow rightRow:(NSInteger)rightRow
{
    self = [super init];
    if (self) {
        _column = column;
        _tableType = tableType;
        _leftRow = leftRow;
        _rightRow = rightRow;
    }
    return self;
}

+ (instancetype)indexPathWithCol:(NSInteger)col tableType:(JSIndexTableType)tableType leftRow:(NSInteger)leftRow rightRow:(NSInteger)rightRow
{
    JSIndexPath *indexPath = [[self alloc] initWithColumn:col tableType:tableType leftRow:leftRow rightRow:rightRow];
    return indexPath;
}

@end
