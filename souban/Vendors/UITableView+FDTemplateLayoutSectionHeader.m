// The MIT License (MIT)
//
// Copyright (c) 2015-1016 forkingdog ( https://github.com/forkingdog )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "UITableView+FDTemplateLayoutCell.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, FDTemplateReuseViewType) {
    FDTemplateReuseViewTypeCell,
    FDTemplateReuseViewTypeSection
};


@implementation UITableView (FDTemplateLayoutSectionHeader)

- (id)fd_templateViewForReuseIdentifier:(NSString *)identifier type:(FDTemplateReuseViewType)type
{
    NSAssert(identifier.length > 0, @"Expects a valid identifier - %@", identifier);

    NSMutableDictionary *templateCellsByIdentifiers = objc_getAssociatedObject(self, _cmd);
    if (!templateCellsByIdentifiers) {
        templateCellsByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateCellsByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    id templateView = templateCellsByIdentifiers[identifier];
    if (!templateView) {
        if (type == FDTemplateReuseViewTypeCell) {
            templateView = [self dequeueReusableCellWithIdentifier:identifier];
        } else {
            templateView = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        }
        templateCellsByIdentifiers[identifier] = templateView;
    }

    return templateView;
}

- (CGFloat)fd_heightForCellWithIdentifier:(NSString *)identifier configuration:(void (^)(id))configuration
{
    // Fetch a cached template cell for `identifier`.
    UITableViewCell *cell = [self fd_templateViewForReuseIdentifier:identifier type:FDTemplateReuseViewTypeCell];
    
    return [self heightForReuseView:cell configuration:configuration];
}

- (CGFloat)fd_heightForSectionWithIdentifier:(NSString *)identifier configuration:(void (^)(id section))configuration
{
    // Fetch a cached template cell for `identifier`.
    UITableViewHeaderFooterView *sectionView = [self fd_templateViewForReuseIdentifier:identifier type:FDTemplateReuseViewTypeSection];
    return [self heightForReuseView:sectionView configuration:configuration];
}

- (CGFloat)heightForReuseView:(id)view configuration:(void (^)(id reuseView))configuration
{
    // Reset to initial height as first created, otherwise the cell's height wouldn't retract if it
    // had larger height before it gets reused.
    [view contentView].bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.rowHeight);

    // Manually calls to ensure consistent behavior with actual cells (that are displayed on screen).
    [view prepareForReuse];

    // Customize and provide content for our template cell.
    if (configuration) {
        configuration(view);
    }

    // Add a hard width constraint to make dynamic content views (like labels) expand vertically instead
    // of growing horizontally, in a flow-layout manner.
    NSLayoutConstraint *tempWidthConstraint =
        [NSLayoutConstraint constraintWithItem:[view contentView]
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1.0
                                      constant:CGRectGetWidth(self.frame)];
    [[view contentView] addConstraint:tempWidthConstraint];

    // Auto layout does its math
    CGSize fittingSize = [[view contentView] systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

    [[view contentView] removeConstraint:tempWidthConstraint];

    // Add 1px extra space for separator line if needed, simulating default UITableViewCell.
    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingSize.height += 1.0 / [UIScreen mainScreen].scale;
    }

    return fittingSize.height;
}
@end
