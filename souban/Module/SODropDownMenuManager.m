//
//  SODropDownMenuManager.m
//  JSDropDownMenuDemo
//
//  Created by 周国勇 on 10/27/15.
//  Copyright © 2015 jsfu. All rights reserved.
//

#import "SODropDownMenuManager.h"
#import "SOBuildingScreenModel.h"
#import "SOScreenItems.h"
#import "NSNumber+Formatter.h"
#import "SOBuildingScreenModel.h"
#import "NSArray+CC.h"

//static NSInteger const location = 0;
//static NSInteger const areaSize = 1;
//static NSInteger const price = 2;
//static NSInteger const others = 3;


@interface SODropDownMenuManager ()

@property (nonatomic) NSInteger tagLeftSelected; // 记录特色左边栏目选中的index
@property (strong, nonatomic) NSMutableArray *columnTitles;


@property (nonatomic) NSInteger location;
@property (nonatomic) NSInteger areaSize;
@property (nonatomic) NSInteger price;
@property (nonatomic) NSInteger others;

@end


@implementation SODropDownMenuManager

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        _dropDownMenu = [[JSDropDownMenu alloc] initWithOrigin:frame.origin andHeight:45];
        _dropDownMenu.delegate = self;
        _dropDownMenu.dataSource = self;
        _screenModel = [SOBuildingScreenModel new];
        _columnTitles = [[NSMutableArray alloc] init];
        _columnTitles = @[ @"区域", @"面积", @"价格", @"其他" ].mutableCopy;
        _location = 0;
        _areaSize = 1;
        _price = 2;
        _others = 3;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame showType:(ShowType)type
{
    self = [super init];
    if (self) {
        _dropDownMenu = [[JSDropDownMenu alloc] initMapDropWithFrame:frame];
        _dropDownMenu.delegate = self;
        _dropDownMenu.dataSource = self;
        _screenModel = [SOBuildingScreenModel new];
        _showType = type;
        _columnTitles = [[NSMutableArray alloc] init];
        _columnTitles = @[ @"面积", @"价格", @"其他" ].mutableCopy;
        _location = 4;
        _areaSize = 0;
        _price = 1;
        _others = 2;
    }
    return self;
}

#pragma mark - JSDropDownMenu
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu
{
    return self.columnTitles.count;
}

- (BOOL)haveRightTableViewInColumn:(NSInteger)column
{
    if (column == _others || column == _location) {
        return YES;
    }
    return NO;
}

- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column
{
    if (column == _others || column == _location) {
        return 0.3;
    }
    return 1;
}

- (NSInteger)rightSelectedRowForLeftRow:(NSInteger)leftRow inColumn:(NSInteger)column
{
    if (column == _others) {
        if (self.screenModel.tagIds.count == 0) {
            return 0;
        }
        SOTagContainer *container = self.screenItems.tags[leftRow];
        NSInteger index = [container.subTags indexOfObjectWithTest:^BOOL(SOTag *obj, NSInteger index) {
            if ([self.screenModel.tagIds containsObject:obj.uniqueId]) {
                return YES;
            }
            return NO;
        }];
        return index == NSNotFound ? 0 : index + 1;
    } else if (column == _location) {
        if (!self.screenModel.areaId) {
            return 0;
        }
        SOArea *area = self.screenItems.areas[leftRow - 1];
        if (!self.screenModel.blockId) {
            return 0;
        }
        NSInteger index = [area.blocks indexOfObjectWithTest:^BOOL(SOTag *obj, NSInteger index) {
            
            if ([obj.uniqueId isEqualToNumber:self.screenModel.blockId]) {
                return YES;
            }
            return NO;
        }];
        return index == NSNotFound ? 0 : index + 1;
    }
    return 0;
}

- (NSInteger)leftSelectedRowInColumn:(NSInteger)column
{
    if (column == _others) {
        return self.tagLeftSelected;
    } else if (column == _location) {
        if (!self.screenModel.areaId) {
            return 0;
        }
        NSInteger index = [self.screenItems.areas indexOfObjectWithTest:^BOOL(SOArea *obj, NSInteger index) {
            if ([obj.uniqueId isEqualToNumber:self.screenModel.areaId]) {
                return YES;
            }
            return NO;
        }];
        return index + 1;

    } else if (column == _price) {
        if (self.screenModel.minPrice && self.screenModel.maxPrice) {
            NSInteger index = [self.screenItems.price indexOfObjectWithTest:^BOOL(SORangeItem *obj, NSInteger index) {
                if ([obj.maxValue isEqualToNumber:self.screenModel.maxPrice] && [obj.minValue isEqualToNumber:self.screenModel.minPrice]) {

                    return YES;
                }
                return NO;
            }];
            return index + 1;
        }
        return 0;
    } else if (column == _areaSize) {
        if (self.screenModel.maxArea && self.screenModel.minArea) {
            NSInteger index = [self.screenItems.areaSize indexOfObjectWithTest:^BOOL(SORangeItem *obj, NSInteger index) {
                if ([obj.maxValue isEqualToNumber:self.screenModel.maxArea] && [obj.minValue isEqualToNumber:self.screenModel.minArea]) {
                    return YES;
                }
                return NO;
            }];
            return index + 1;
        }
        return 0;
    }
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu leftNumberOfRowsInColumn:(NSInteger)column
{
    if (column == _others) {
        return self.screenItems.tags.count;
    } else if (column == _location) {
        return self.screenItems.areas.count + 1;
    } else if (column == _price) {
        return self.screenItems.price.count + 1;
    } else {
        return self.screenItems.areaSize.count + 1;
    }
}

- (NSInteger)menu:(JSDropDownMenu *)menu rightNumberOfRowsInColumn:(NSInteger)column leftRow:(NSInteger)leftRow
{
    if (column == _others) {
        SOTagContainer *container = self.screenItems.tags[leftRow];
        return container.subTags.count + 1;
    } else if (column == _location) {
        if (leftRow == 0) {
            return 0;
        }
        SOArea *area = self.screenItems.areas[leftRow - 1];
        return area.blocks.count + 1;
    } else {
        return 0;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column
{
    return self.columnTitles[column];
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath
{
    NSString *title = nil;
    if (indexPath.column == _others) {
        if (indexPath.tableType == JSIndexTableTypeLeft) {
            SOTagContainer *container = self.screenItems.tags[indexPath.leftRow];
            title = container.name;
        } else {
            if (indexPath.rightRow == 0) {
                title = @"不限";
            } else {
                SOTagContainer *container = self.screenItems.tags[indexPath.leftRow];
                SOTag *tag = container.subTags[indexPath.rightRow - 1];
                title = tag.name;
            }
        }

    } else if (indexPath.column == _location) {
        if (indexPath.tableType == JSIndexTableTypeLeft) {
            if (indexPath.leftRow == 0) {
                title = @"不限";
            } else {
                SOArea *area = self.screenItems.areas[indexPath.leftRow - 1];
                title = area.name;
            }
        } else {
            if (indexPath.leftRow == 0 || indexPath.rightRow == 0) {
                title = @"不限";
            } else {
                SOArea *area = self.screenItems.areas[indexPath.leftRow - 1];
                SOTag *tag = area.blocks[indexPath.rightRow - 1];
                title = tag.name;
            }
        }
    } else if (indexPath.column == _price) {
        if (indexPath.leftRow == 0) {
            title = @"不限";
        } else {
            SORangeItem *range = self.screenItems.price[indexPath.leftRow - 1];
            if (range.maxValue.integerValue == kMaxRangeValue) {
                title = [NSString stringWithFormat:@"%@以上", [range.minValue buiildingPriceStringForUnit:range.priceUnit]];
            } else {
                title = [NSString stringWithFormat:@"%@-%@", range.minValue.twoBitStringValue, [range.maxValue buiildingPriceStringForUnit:range.priceUnit]];
            }
        }
    } else if (indexPath.column == _areaSize) {
        if (indexPath.leftRow == 0) {
            title = @"不限";
        } else {
            SORangeItem *range = self.screenItems.areaSize[indexPath.leftRow - 1];
            if (range.maxValue.integerValue == kMaxRangeValue) {
                title = [NSString stringWithFormat:@"%@平米以上", range.minValue];
            } else {
                title = [NSString stringWithFormat:@"%@-%@平米", range.minValue, range.maxValue];
            }
        }
    }
    return title;
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath
{
    if (indexPath.column == _others) {
        if (indexPath.tableType == JSIndexTableTypeRight) {
            SOTagContainer *container = self.screenItems.tags[indexPath.leftRow];
            if (indexPath.rightRow == 0) {
                for (SOTag *tag in container.subTags) {
                    [self.screenModel.tagIds removeUniqueId:tag.uniqueId];
                }
            } else {
                SOTagContainer *container = self.screenItems.tags[indexPath.leftRow];
                for (SOTag *tag in container.subTags) {
                    if ([self.screenModel.tagIds containsObject:tag.uniqueId]) {
                        [self.screenModel.tagIds removeObject:tag.uniqueId];
                    }
                }
                SOTag *tag = container.subTags[indexPath.rightRow - 1];
                [self.screenModel.tagIds addObject:tag.uniqueId];
            }
            NSMutableArray *array = [NSMutableArray new];
            for (SOTagContainer *container in self.screenItems.tags) {
                for (SOTag *tag in container.subTags) {
                    for (NSNumber *uniqueId in self.screenModel.tagIds) {
                        if ([uniqueId isEqualToNumber:tag.uniqueId]) {
                            [array addObject:tag.name];
                        }
                    }
                }
            }

            self.columnTitles[indexPath.column] = array.count == 0 ? @"其他" : [array componentsJoinedByString:@" "];
            [self.dropDownMenu dismissMenu];
        } else {
            self.tagLeftSelected = indexPath.leftRow;
        }
    } else if (indexPath.column == _location) {
        if (indexPath.tableType == JSIndexTableTypeRight) {
            if (indexPath.leftRow == 0) {
                self.screenModel.blockId = nil;
                SOArea *area = self.screenItems.areas[indexPath.leftRow - 1];
                self.columnTitles[indexPath.column] = area.name;
            } else {
                if (indexPath.rightRow == 0) {
                    self.screenModel.blockId = nil;
                    SOArea *area = self.screenItems.areas[indexPath.leftRow - 1];
                    self.columnTitles[indexPath.column] = area.name;
                } else {
                    SOArea *container = self.screenItems.areas[indexPath.leftRow - 1];
                    SOTag *tag = container.blocks[indexPath.rightRow - 1];
                    self.screenModel.blockId = tag.uniqueId;
                    self.columnTitles[indexPath.column] = tag.name;
                }
            }
            [self.dropDownMenu dismissMenu];
        } else {
            if (indexPath.leftRow == 0) {
                self.screenModel.blockId = nil;
                self.screenModel.areaId = nil;
                self.columnTitles[indexPath.column] = @"区域";
                [self.dropDownMenu dismissMenu];
            } else {
                SOArea *container = self.screenItems.areas[indexPath.leftRow - 1];
                self.screenModel.blockId = nil;
                self.screenModel.areaId = container.uniqueId;
                self.columnTitles[indexPath.column] = container.name;
            }
        }
    } else if (indexPath.column == _price) {
        if (indexPath.leftRow == 0) {
            self.screenModel.maxPrice = nil;
            self.screenModel.minPrice = nil;
        } else {
            self.screenModel.maxPrice = [self.screenItems.price[indexPath.leftRow - 1] maxValue];
            self.screenModel.minPrice = [self.screenItems.price[indexPath.leftRow - 1] minValue];
        }

        NSString *title = nil;
        SORangeItem *range = self.screenItems.price.firstObject;
        if (self.screenModel.maxPrice.floatValue < kMaxRangeValue) {
            title = [NSString stringWithFormat:@"%@-%@", self.screenModel.minPrice.twoBitStringValue, [self.screenModel.maxPrice buiildingPriceStringForUnit:range.priceUnit]];

        } else {
            title = [NSString stringWithFormat:@"%@以上", [self.screenModel.minPrice buiildingPriceStringForUnit:range.priceUnit]];
        }
        self.columnTitles[indexPath.column] = indexPath.leftRow == 0 ? @"价格" : title;
        [self.dropDownMenu dismissMenu];
    } else if (indexPath.column == _areaSize) {
        if (indexPath.leftRow == 0) {
            self.screenModel.maxArea = nil;
            self.screenModel.minArea = nil;
        } else {
            self.screenModel.maxArea = [self.screenItems.areaSize[indexPath.leftRow - 1] maxValue];
            self.screenModel.minArea = [self.screenItems.areaSize[indexPath.leftRow - 1] minValue];
        }
        NSString *title = nil;
        if (self.screenModel.maxArea.floatValue < kMaxRangeValue) {
            title = [NSString stringWithFormat:@"%@-%@平米", self.screenModel.minArea.stringValue, self.screenModel.maxArea.stringValue];
        } else {
            title = [NSString stringWithFormat:@"%@平米以上", self.screenModel.minArea.stringValue];
        }
        self.columnTitles[indexPath.column] = indexPath.leftRow == 0 ? @"面积" : title;

        [self.dropDownMenu dismissMenu];
    }
    [self.dropDownMenu reloadHeaderForColumn:indexPath.column];
}

- (void)menuWillDismiss:(JSDropDownMenu *)menu
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(needRefreshData)]) {
        [self.delegate needRefreshData];
    }
}


- (void)setScreenModel:(SOBuildingScreenModel *)screenModel
{
    NSString *areaString = screenModel.maxArea ? [NSString stringWithFormat:@"%@-%@平米", screenModel.minArea, screenModel.maxArea] : @"面积";
    NSString *priceString = screenModel.maxPrice ? [NSString stringWithFormat:@"%@-%@/m²·天", screenModel.minPrice, screenModel.maxPrice] : @"价格";
    NSMutableArray *array = [NSMutableArray new];
    for (SOTagContainer *container in self.screenItems.tags) {
        for (SOTag *tag in container.subTags) {
            for (NSNumber *uniqueId in screenModel.tagIds) {
                if ([uniqueId isEqualToNumber:tag.uniqueId]) {
                    [array addObject:tag.name];
                }
            }
        }
    }
    NSString *tagString = array.count == 0 ? @"其他" : [array componentsJoinedByString:@" "];

    NSArray *titles = @[ areaString, priceString, tagString ];
    [self.dropDownMenu setHeaderForColumnWithTitles:titles];

    if (self.delegate && [self.delegate respondsToSelector:@selector(needRefreshData)]) {
        [self.delegate needRefreshData];
    }
    _screenModel = screenModel;
}


@end
