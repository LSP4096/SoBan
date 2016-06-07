//
//  UITableView+RegisterNib.h
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITableView (RegisterNib)

- (void)registerCellNibWithClassIdentifier:(NSString *)identifier;

- (void)registerCellNibWithClassIdentifiers:(NSArray<NSString *> *)identifiers;

- (void)registerHeaderFooterWithClassIdentifier:(NSString *)identifier;

- (void)registerHeaderFooterWithClassIdentifiers:(NSArray<NSString *> *)identifiers;

@end
