//
//  DSHCollectionViewWaterfallFlowLayout.m
//  CollectionViewCustomLayout
//
//  Created by 路 on 2020/6/18.
//  Copyright © 2020 路. All rights reserved.
//

#import "DSHCollectionViewWaterfallFlowLayout.h"

@interface DSHCollectionViewWaterfallFlowLayout ()

@property (strong ,nonatomic) NSMutableDictionary *originalHeaderRect; // 保存 header 的位置
@property (strong ,nonatomic) NSMutableDictionary *originalFooterRect; // 保存 footer 的位置
@end

@implementation DSHCollectionViewWaterfallFlowLayout {
    NSArray <UICollectionViewLayoutAttributes *>*_layoutAttributes;
    CGFloat _maxY;
}

- (void)prepareLayout; {
    [super prepareLayout];
    
    NSMutableArray *result = [NSMutableArray array];
    CGFloat maxY = 0.f;
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    
    if (_sectionHeadersPinToVisibleBounds || _sectionFootersPinToVisibleBounds) {
        _originalHeaderRect = [NSMutableDictionary dictionaryWithCapacity:numberOfSections];
        _originalFooterRect = [NSMutableDictionary dictionaryWithCapacity:numberOfSections];
    }
    
    for (int section = 0; section < numberOfSections; section ++) {
        id<DSHCollectionViewDelegateWaterfallFlowLayout> delegate = (id<DSHCollectionViewDelegateWaterfallFlowLayout>)self.collectionView.delegate;
        // MARK: - 获取布局参数
        NSInteger columnNumber = _columnNumber;
        if ([delegate respondsToSelector:@selector(waterfallFlowLayout:collectionView:numberOfColumnAtSection:)]) {
            columnNumber = [delegate waterfallFlowLayout:self collectionView:self.collectionView numberOfColumnAtSection:section];
        }
        if (columnNumber <= 0) {
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
            _originalHeaderRect[@(section)] = @(frame);
        } else {
            _originalHeaderRect[@(section)] = @(CGRectMake(0, maxY, 0, 0));
        }
        
        // MARK: - 元素
        // 计算元素宽度
        CGFloat width = (self.collectionView.frame.size.width - sectionInset.left - sectionInset.right - (columnNumber - 1) * interitemSpacing) / columnNumber;
        // 创建一个float数组用来记录每列的高度(位置)
        CGFloat columnY[columnNumber];
        for (int i = 0; i < columnNumber; i ++) columnY[i] = maxY;
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        for (int row = 0; row < numberOfItemsInSection; row ++) {
            NSInteger column = 0; // 要往第几列插数据
            CGFloat y = MAXFLOAT; // 插入的位置
            for (int i = 0; i < columnNumber; i ++) {
                CGFloat _y = columnY[i];
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
                columnY[column] = CGRectGetMaxY(frame);
            }
        }
        for (int i = 0; i < columnNumber; i ++) maxY = MAX(maxY, columnY[i]);
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
            _originalFooterRect[@(section)] = @(frame);
        } else {
            _originalFooterRect[@(section)] = @(CGRectMake(0, maxY, 0, 0));
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
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGFloat top = contentOffset.y; // 当前顶部位置
    CGFloat bottom = top + self.collectionView.bounds.size.height; // 当前底部位置
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets adjustedContentInset = self.collectionView.adjustedContentInset;
        top = top + adjustedContentInset.top;
        bottom = bottom - adjustedContentInset.bottom;
    }
    for (UICollectionViewLayoutAttributes *attr in _layoutAttributes) {
        CGRect frame = attr.frame;
        NSInteger section = attr.indexPath.section;
        if (_sectionHeadersPinToVisibleBounds && attr.representedElementKind == UICollectionElementKindSectionHeader) {
            NSValue *headerRect = _originalHeaderRect[@(section)];
            if (top > headerRect.CGRectValue.origin.y) {
                frame.origin.y = top;
                NSValue *nextRect = _originalFooterRect[@(section)];
                if (CGRectGetMaxY(frame) > nextRect.CGRectValue.origin.y) {
                    frame.origin.y = nextRect.CGRectValue.origin.y - frame.size.height;
                }
            }
        }
        if (_sectionFootersPinToVisibleBounds && attr.representedElementKind == UICollectionElementKindSectionFooter) {
            NSValue *headerRect = _originalHeaderRect[@(section)];
            NSValue *footerRect = _originalFooterRect[@(section)];
            if (bottom < CGRectGetMaxY(footerRect.CGRectValue) && bottom > headerRect.CGRectValue.origin.y) {
                frame.origin.y = bottom - frame.size.height;
                if (frame.origin.y < CGRectGetMaxY(headerRect.CGRectValue)) {
                    frame.origin.y = CGRectGetMaxY(headerRect.CGRectValue);
                }
            }
        }
        attr.frame = frame;
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
