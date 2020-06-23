//
//  DSHCollectionViewCardStackLayout.m
//  CollectionViewCustomLayout
//
//  Created by 路 on 2020/6/19.
//  Copyright © 2020 路. All rights reserved.
//

#import "DSHCollectionViewCardStackLayout.h"

@implementation DSHCollectionViewCardStackLayout {
    NSArray <UICollectionViewLayoutAttributes *>*_layoutAttributes;
}

- (void)prepareLayout; {
    [super prepareLayout];
    NSMutableArray <UICollectionViewLayoutAttributes *>*result = [NSMutableArray array];
    NSInteger numberOfSection = self.collectionView.numberOfSections;
    for (int section = 0; section < numberOfSection; section ++) {
        NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:section];
        for (int row = 0; row < numberOfItem; row ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            @autoreleasepool {
                UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                attr.bounds = (CGRect){CGPointZero,_itemSize};
                attr.zIndex = - ((section + 1) * row);
                [result addObject:attr];
            }
        }
    }
    _layoutAttributes = result.copy;
}

- (CGSize)collectionViewContentSize; {
    CGSize result = self.collectionView.bounds.size;
    NSInteger numberOfSection = self.collectionView.numberOfSections;
    NSInteger numberOfItem = 0;
    if (_chooseModeSupported) {
        numberOfItem = 3;
    } else {
        for (int section = 0; section < numberOfSection; section ++) {
            numberOfItem += [self.collectionView numberOfItemsInSection:section];
        }
    }
    if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        result.width = result.width * numberOfItem;
    } else if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
        result.height = result.height * numberOfItem;
    }
    return result;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect; {
    CGPoint contentOffset = self.collectionView.contentOffset;
    // 标记元素有没有被遮挡，实测不管有没有被遮挡，只要处于可视坐标范围内，UICollectionView 都会创建一条 cell 并添加到容器内，而实际上被遮挡住的元素并不需要创建出来，在这里处理一下可以有效的利用 UICollectionView 自身的重用机制
    BOOL masked = NO;
    for (UICollectionViewLayoutAttributes *attr in _layoutAttributes) {
        CGPoint center = attr.center;
        CGFloat scaleOffset = 0.f;
        NSInteger visibleItemCount = 3; // 卡片堆叠起来后后面可见的堆叠的卡片数量
        if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            // 左右滑动业务
            center.y = self.collectionView.bounds.size.height * .5;
            center.x = contentOffset.x + self.collectionView.bounds.size.width * .5;
            // 根据元素的 indexPath 固定当前元素的位置
            CGFloat x = self.collectionView.bounds.size.width * (attr.indexPath.row + .5);
            center.x = MIN(center.x, x);
            // 最终的位置相对于当前实际的位置偏移了多少个容器宽度
            scaleOffset = MIN(visibleItemCount, (x - center.x) / self.collectionView.bounds.size.width);
            
            if (_chooseModeSupported) {
                CGSize contentSize = self.collectionViewContentSize;
                if (attr.indexPath.row == 0) {
                    center.x = contentSize.width * .5;
                    scaleOffset = 0;
                } else {
                    center.x = contentOffset.x + self.collectionView.bounds.size.width * .5;
                    CGFloat dis = fabs(contentOffset.x - self.collectionView.bounds.size.width);
                    scaleOffset = MIN(visibleItemCount, attr.indexPath.row - (dis / self.collectionView.bounds.size.width));
                }
            }
            
        } else if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
            // 上下滑动业务
            center.x = self.collectionView.bounds.size.width * .5;
            center.y = contentOffset.y + self.collectionView.bounds.size.height * .5;
            // 根据元素的 indexPath 固定当前元素的位置
            CGFloat y = self.collectionView.bounds.size.height * (attr.indexPath.row + .5);
            center.y = MIN(center.y, y);
            // 最终的位置相对于当前实际的位置偏移了多少个容器高度
            scaleOffset = MIN(visibleItemCount, (y - center.y) / self.collectionView.bounds.size.height);
            
            if (_chooseModeSupported) {
                CGSize contentSize = self.collectionViewContentSize;
                if (attr.indexPath.row == 0) {
                    center.y = contentSize.height * .5;
                    scaleOffset = 0;
                } else {
                    center.y = contentOffset.y + self.collectionView.bounds.size.height * .5;
                    CGFloat dis = fabs(contentOffset.y - self.collectionView.bounds.size.height);
                    scaleOffset = MIN(visibleItemCount, attr.indexPath.row - (dis / self.collectionView.bounds.size.height));
                }
            }
        }
        
        // 计算元素缩放大小
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformMakeScale(1 - scaleOffset / 10.f, 1 - scaleOffset / 10.f);
        
        // 计算卡片偏移量
        CGSize itemSize = CGSizeApplyAffineTransform(_itemSize, transform); // 缩放后的元素大小
        CGSize diff_size = CGSizeMake(_itemSize.width - itemSize.width, _itemSize.height - itemSize.height); // 缩放后的大小与元素实际大小的差值
        // 偏移后的位置 = 当前实际的中心点 + 实际宽高与缩放之后的宽高的差值的一半 + 当前元素偏移度
        if (_itemOffset.horizontal != 0) {
            CGFloat half_diff_width = diff_size.width * .5;
            half_diff_width = half_diff_width * (_itemOffset.horizontal > 0 ? 1 : -1); // 转换符号
            center.x = center.x + half_diff_width + _itemOffset.horizontal * scaleOffset;
        }
        if (_itemOffset.vertical != 0) {
            CGFloat half_diff_height = diff_size.height * .5;
            half_diff_height = half_diff_height * (_itemOffset.vertical > 0 ? 1 : -1); // 转换符号
            center.y = center.y + half_diff_height + _itemOffset.vertical * scaleOffset;
        }
        // 被遮挡的元素移出屏幕外，确保处于不可见的位置
        if (masked) {
            center.x = contentOffset.x + self.collectionView.bounds.size.width + _itemSize.width;
            center.y = contentOffset.y + self.collectionView.bounds.size.height + _itemSize.height;
        }
        // 在最小缩放之后的元素全部标记为被遮挡
        if (scaleOffset == visibleItemCount) {
            masked = YES;
        }
        attr.center = center;
        attr.transform = transform;
    }
    return _layoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds; {
    return YES;
}
@end
