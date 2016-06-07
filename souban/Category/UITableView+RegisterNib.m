//
//  UITableView+RegisterNib.m
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "UITableView+RegisterNib.h"


@implementation UITableView (RegisterNib)

- (void)registerCellNibWithClassIdentifier:(NSString *)identifier
{
    [self registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
}

- (void)registerCellNibWithClassIdentifiers:(NSArray<NSString *> *)identifiers
{
    for (NSString *identifier in identifiers) {
        [self registerCellNibWithClassIdentifier:identifier];
    }
}

- (void)registerHeaderFooterWithClassIdentifier:(NSString *)identifier
{
    [self registerNib:[UINib nibWithNibName:identifier bundle:nil] forHeaderFooterViewReuseIdentifier:identifier];
}

- (void)registerHeaderFooterWithClassIdentifiers:(NSArray<NSString *> *)identifiers
{
    for (NSString *identifier in identifiers) {
        [self registerHeaderFooterWithClassIdentifier:identifier];
    }
}
@end
