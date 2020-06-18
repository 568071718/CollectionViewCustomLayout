//
//  UICollectionView+DSHCustomLayout.m
//  CollectionViewCustomLayout
//
//  Created by 路 on 2020/6/18.
//  Copyright © 2020 路. All rights reserved.
//

#import "UICollectionView+DSHCustomLayout.h"
#import <objc/runtime.h>
#import "DSHCollectionViewPagingLayout.h"

@implementation UICollectionView (DSHCustomLayout)

+ (void)load; {
    Method m1 = class_getInstanceMethod([self class], @selector(scrollToItemAtIndexPath:atScrollPosition:animated:));
    Method m2 = class_getInstanceMethod([self class], @selector(_dshCustomLayoutScrollToItemAtIndexPath:atScrollPosition:animated:));
    method_exchangeImplementations(m1, m2);
}

- (void)_dshCustomLayoutScrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated; {
    UICollectionViewLayout *collectionViewLayout = self.collectionViewLayout;
    if ([collectionViewLayout isKindOfClass:[DSHCollectionViewPagingLayout class]]) {
        UICollectionViewCell *cell = [self.dataSource collectionView:self cellForItemAtIndexPath:indexPath];
        NSInteger page = floor(cell.frame.origin.x / self.frame.size.width); // 计算出将要滚动到第几页
        CGRect visibleRect = self.bounds;
        visibleRect.origin.x = page * self.frame.size.width;
        [self scrollRectToVisible:visibleRect animated:animated];
        return;
    }
    [self _dshCustomLayoutScrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

@end
