//
//  UICollectionView+RegisterNib.m
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "UICollectionView+RegisterNib.h"


@implementation UICollectionView (RegisterNib)

- (void)registerCellNibWithClassIdentifier:(NSString *)identifier
{
    [self registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
}

- (void)registerCellNibWithClassIdentifiers:(NSArray<NSString *> *)identifiers
{
    for (NSString *idetifier in identifiers) {
        [self registerCellNibWithClassIdentifier:idetifier];
    }
}

- (void)registerHeaderNibWithClassIdentifier:(NSString *)identifier
{
    [self registerNib:[UINib nibWithNibName:identifier bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

- (void)registerHeaderNibWithClassIdentifiers:(NSArray<NSString *> *)identifiers
{
    for (NSString *identifier in identifiers) {
        [self registerCellNibWithClassIdentifier:identifier];
    }
}

- (void)registerFooterNibWithClassIdentifier:(NSString *)identifier
{
    [self registerNib:[UINib nibWithNibName:identifier bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
}

- (void)registerFooterNibWithClassIdentifiers:(NSArray<NSString *> *)identifiers
{
    for (NSString *identifier in identifiers) {
        [self registerFooterNibWithClassIdentifier:identifier];
    }
}
@end
