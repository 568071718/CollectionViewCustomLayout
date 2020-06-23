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
#import "DSHCollectionViewCardStackLayout.h"

@implementation UICollectionView (DSHCustomLayout)

+ (void)load; {
    {
        Method m1 = class_getInstanceMethod([self class], @selector(scrollToItemAtIndexPath:atScrollPosition:animated:));
        Method m2 = class_getInstanceMethod([self class], @selector(_dshCustomLayoutScrollToItemAtIndexPath:atScrollPosition:animated:));
        method_exchangeImplementations(m1, m2);
    }
    {
        Method m1 = class_getInstanceMethod([self class], @selector(reloadData));
        Method m2 = class_getInstanceMethod([self class], @selector(_dshCustomLayoutReloadData));
        method_exchangeImplementations(m1, m2);
    }
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

- (void)_dshCustomLayoutReloadData; {
    UICollectionViewLayout *collectionViewLayout = self.collectionViewLayout;
    if ([collectionViewLayout isKindOfClass:[DSHCollectionViewCardStackLayout class]]) {
        DSHCollectionViewCardStackLayout *layout = (DSHCollectionViewCardStackLayout *)collectionViewLayout;
        // 在挑选模式下自动滚动到中心位置，考虑到加载更多需求(预加载)，这里仅仅是在 collectionView 完全静止并且没有任何拖动行为的时候执行
        if (layout.chooseModeSupported && !self.tracking && !self.dragging && !self.decelerating) {
            if (layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                self.contentOffset = CGPointMake(self.bounds.size.width, 0);
            } else if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
                self.contentOffset = CGPointMake(0, self.bounds.size.height);
            }
        }
    }
    [self _dshCustomLayoutReloadData];
}

@end
