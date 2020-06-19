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
}

- (void)prepareLayout; {
    [super prepareLayout];
    if (_columnNumber <= 0) {
        return;
    }
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray <NSNumber *>*maxY = [NSMutableArray arrayWithCapacity:_columnNumber];
    for (int i = 0; i < _columnNumber; i ++) maxY[i] = @(0);
    
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    // 计算元素宽度
    CGFloat width = (self.collectionView.frame.size.width - _sectionInset.left - _sectionInset.right - (_columnNumber - 1) * _interitemSpacing) / _columnNumber;
    for (int section = 0; section < numberOfSections; section ++) {
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        for (int row = 0; row < numberOfItemsInSection; row ++) {
            NSInteger column = 0; // 要往第几列插数据
            CGFloat y = MAXFLOAT;
            for (int i = 0; i < maxY.count; i ++) {
                CGFloat _y = maxY[i].floatValue;
                if (_y < y) {
                    y = _y; column = i;
                }
            }
            y = y + (y == 0 ? _sectionInset.top : _lineSpacing);
            CGFloat x = _sectionInset.left + column * (width + _interitemSpacing);
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            // 获取元素高度
            CGFloat height = _itemHeight;
            id<DSHCollectionViewDelegateWaterfallFlowLayout> delegate = (id<DSHCollectionViewDelegateWaterfallFlowLayout>)self.collectionView.delegate;
            if ([delegate respondsToSelector:@selector(waterfallFlowLayout:collectionView:heightForItemAtIndexPath:itemWidth:)]) {
                height = [delegate waterfallFlowLayout:self collectionView:self.collectionView heightForItemAtIndexPath:indexPath itemWidth:width];
            }
            // 创建单元属性
            @autoreleasepool {
                UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                CGRect frame = attr.frame;
                frame.origin.x = x;
                frame.origin.y = y;
                frame.size.width = width;
                frame.size.height = height;
                attr.frame = frame;
                [result addObject:attr];
                maxY[column] = @(CGRectGetMaxY(frame));
            }
        }
    }
    _layoutAttributes = result.copy;
}

- (CGSize)collectionViewContentSize; {
    // 遍历所有元素，找到最底部的元素的位置就是自身容器的高度
    CGSize result = self.collectionView.bounds.size;
    for (UICollectionViewLayoutAttributes *attr in _layoutAttributes) {
        result.height = MAX(result.height, CGRectGetMaxY(attr.frame));
    }
    result.height = result.height + _sectionInset.bottom;
    return result;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect; {
    return _layoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds; {
    if (!CGSizeEqualToSize(self.collectionView.frame.size, newBounds.size)) {
        return YES;
    }
    return NO;
}
@end
