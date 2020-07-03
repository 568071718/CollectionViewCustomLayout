//
//  DSHCollectionViewWaterfallFlowLayout.m
//  CollectionViewCustomLayout
//
//  Created by 路 on 2020/6/18.
//  Copyright © 2020 路. All rights reserved.
//

#import "DSHCollectionViewWaterfallFlowLayout.h"

@implementation DSHCollectionViewWaterfallFlowLayout {
    NSArray <UICollectionViewLayoutAttributes *>*_layoutAttributes;
    CGFloat _maxY;
}

- (void)prepareLayout; {
    [super prepareLayout];
    if (_columnNumber <= 0) {
        return;
    }
    NSMutableArray *result = [NSMutableArray array];
    CGFloat maxY = 0.f;
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    
    for (int section = 0; section < numberOfSections; section ++) {
        id<DSHCollectionViewDelegateWaterfallFlowLayout> delegate = (id<DSHCollectionViewDelegateWaterfallFlowLayout>)self.collectionView.delegate;
        // MARK: - 获取布局参数
        NSInteger columnNumber = _columnNumber;
        if ([delegate respondsToSelector:@selector(waterfallFlowLayout:collectionView:numberOfColumnAtSection:)]) {
            columnNumber = [delegate waterfallFlowLayout:self collectionView:self.collectionView numberOfColumnAtSection:section];
        }
        if (columnNumber < 0) {
#if DEBUG
            NSLog(@"*** 错误: %s [columnNumber 必须大于 0]" ,__func__);
#endif
            return;
        }
        CGFloat lineSpacing = _lineSpacing;
        if ([delegate respondsToSelector:@selector(waterfallFlowLayout:collectionView:spacingForLineAtSection:)]) {
            lineSpacing = [delegate waterfallFlowLayout:self collectionView:self.collectionView spacingForLineAtSection:section];
        }
        CGFloat interitemSpacing = _interitemSpacing;
        if ([delegate respondsToSelector:@selector(waterfallFlowLayout:collectionView:spacingForItemAtSection:)]) {
            interitemSpacing = [delegate waterfallFlowLayout:self collectionView:self.collectionView spacingForItemAtSection:section];
        }
        UIEdgeInsets sectionInset = _sectionInset;
        if ([delegate respondsToSelector:@selector(waterfallFlowLayout:collectionView:sectionInsetAtSection:)]) {
            sectionInset = [delegate waterfallFlowLayout:self collectionView:self.collectionView sectionInsetAtSection:section];
        }
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        
        // MARK: - 区头
        CGFloat headerHeight = 0;
        if ([delegate respondsToSelector:@selector(waterfallFlowLayout:collectionView:heightForHeaderInSection:)]) {
            headerHeight = [delegate waterfallFlowLayout:self collectionView:self.collectionView heightForHeaderInSection:section];
        }
        if (headerHeight > 0) {
            UICollectionViewLayoutAttributes *headerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:sectionIndexPath];
            CGRect frame = CGRectZero;
            frame.origin.x = 0.f;
            frame.origin.y = maxY;
            frame.size.width = self.collectionView.bounds.size.width;
            frame.size.height = headerHeight;
            headerAttr.frame = frame;
            headerAttr.zIndex = 1;
            [result addObject:headerAttr];
            maxY = CGRectGetMaxY(frame);
        }
        
        // MARK: - 元素
        // 计算元素宽度
        CGFloat width = (self.collectionView.frame.size.width - sectionInset.left - sectionInset.right - (columnNumber - 1) * interitemSpacing) / columnNumber;
        // 创建一个数组用来记录每列的高度(位置)
        NSMutableArray <NSNumber *>*columnY = [NSMutableArray arrayWithCapacity:columnNumber];
        for (int i = 0; i < columnNumber; i ++) columnY[i] = @(maxY);
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        for (int row = 0; row < numberOfItemsInSection; row ++) {
            NSInteger column = 0; // 要往第几列插数据
            CGFloat y = MAXFLOAT; // 插入的位置
            for (int i = 0; i < columnY.count; i ++) {
                CGFloat _y = columnY[i].floatValue;
                if (_y < y) {
                    y = _y; column = i;
                }
            }
            y = y + (y == maxY ? sectionInset.top : lineSpacing);
            CGFloat x = sectionInset.left + column * (width + interitemSpacing);
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            // 获取元素高度
            CGFloat itemHeight = _itemHeight;
            if ([delegate respondsToSelector:@selector(waterfallFlowLayout:collectionView:heightForItemAtIndexPath:itemWidth:)]) {
                itemHeight = [delegate waterfallFlowLayout:self collectionView:self.collectionView heightForItemAtIndexPath:indexPath itemWidth:width];
            }
            // 创建单元属性
            @autoreleasepool {
                UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                CGRect frame = attr.frame;
                frame.origin.x = x;
                frame.origin.y = y;
                frame.size.width = width;
                frame.size.height = itemHeight;
                attr.frame = frame;
                [result addObject:attr];
                columnY[column] = @(CGRectGetMaxY(frame));
            }
        }
        for (NSNumber *number in columnY) maxY = MAX(maxY, number.floatValue);
        maxY = maxY + sectionInset.bottom;
        
        // MARK: - 区尾
        CGFloat footerHeight = 0.f;
        if ([delegate respondsToSelector:@selector(waterfallFlowLayout:collectionView:heightForFooterInSection:)]) {
            footerHeight = [delegate waterfallFlowLayout:self collectionView:self.collectionView heightForFooterInSection:section];
        }
        if (footerHeight > 0) {
            UICollectionViewLayoutAttributes *footerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:sectionIndexPath];
            CGRect frame = CGRectZero;
            frame.origin.x = 0.f;
            frame.origin.y = maxY;
            frame.size.width = self.collectionView.bounds.size.width;
            frame.size.height = footerHeight;
            footerAttr.frame = frame;
            footerAttr.zIndex = 1;
            [result addObject:footerAttr];
            maxY = CGRectGetMaxY(frame);
        }
    }
    _maxY = maxY;
    _layoutAttributes = result.copy;
}

- (CGSize)collectionViewContentSize; {
    // 遍历所有元素，找到最底部的元素的位置就是自身容器的高度
    CGSize result = self.collectionView.bounds.size;
    result.height = _maxY;
    return result;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect; {
    for (UICollectionViewLayoutAttributes *attr in _layoutAttributes) {
    }
    return _layoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds; {
    if (_sectionHeadersPinToVisibleBounds || _sectionFootersPinToVisibleBounds) {
        return YES;
    }
    if (!CGSizeEqualToSize(self.collectionView.frame.size, newBounds.size)) {
        return YES;
    }
    return NO;
}
@end
