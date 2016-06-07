//
//  UICollectionView+RegisterNib.h
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UICollectionView (RegisterNib)
/**
 *  快速注册方法
 *
 *  @param identifier 必须保持ClassName和identifier一致
 */
- (void)registerCellNibWithClassIdentifier:(NSString *)identifier;

- (void)registerCellNibWithClassIdentifiers:(NSArray<NSString *> *)identifiers;

- (void)registerHeaderNibWithClassIdentifier:(NSString *)identifier;

- (void)registerHeaderNibWithClassIdentifiers:(NSArray<NSString *> *)identifiers;

- (void)registerFooterNibWithClassIdentifier:(NSString *)identifier;

- (void)registerFooterNibWithClassIdentifiers:(NSArray<NSString *> *)identifiers;

@end
