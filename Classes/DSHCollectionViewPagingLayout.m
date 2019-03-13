//
//  DSHCollectionViewPagingLayout.m
//  DSHCollectionViewPagingLayout
//
//  Created by 路 on 2019/3/12.
//  Copyright © 2019年 路. All rights reserved.
//

#import "DSHCollectionViewPagingLayout.h"

@interface DSHCollectionViewPagingLayout ()
@property (strong ,nonatomic) NSMutableDictionary <NSNumber/** section */ * ,NSArray <NSNumber/** 页码 */ *>*>*sectionPages;
@end

@implementation DSHCollectionViewPagingLayout

- (id)init {
    self = [super init];
    if (self) {
        _rowNumber = 1;
        _columnNumber = 1;
    } return self;
}

#pragma mark - Every layout object should implement the following methods
- (CGSize)collectionViewContentSize {
    CGSize size = self.collectionView.frame.size;
    NSInteger numberOfSections = 1;
    if ([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        numberOfSections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    NSInteger numberOfPage = 0; // 计算一共有多少页数据
    for (int section = 0; section < numberOfSections; section ++) {
        NSInteger numberOfItemsInSection = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
        
        NSInteger rowNumber = _rowNumber;
        if ([self._dsh_delegate respondsToSelector:@selector(collectionView:layout:rowNumberForSectionAtIndex:)]) {
            rowNumber = [self._dsh_delegate collectionView:self.collectionView layout:self rowNumberForSectionAtIndex:section];
        }
        
        NSInteger columnNumber = _columnNumber;
        if ([self._dsh_delegate respondsToSelector:@selector(collectionView:layout:columnNumberForSectionAtIndex:)]) {
            columnNumber = [self._dsh_delegate collectionView:self.collectionView layout:self columnNumberForSectionAtIndex:section];
        }
        
        CGFloat numberOfItemInPage = rowNumber * columnNumber;
        NSInteger numberOfPageInSection = ceil(numberOfItemsInSection / numberOfItemInPage);
        numberOfPage += numberOfPageInSection;
    }
    size.width = size.width * numberOfPage;
    return size;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray <UICollectionViewLayoutAttributes *>*result = [NSMutableArray array];
    NSInteger numberOfSections = 1;
    if ([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        numberOfSections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    
    CGFloat x = 0;
    NSInteger pageIndex = 0;
    for (int section = 0; section < numberOfSections; section ++) {
        
        UIEdgeInsets sectionInset = _sectionInset;
        if ([self._dsh_delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            sectionInset = [self._dsh_delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        }
        
        NSInteger rowNumber = _rowNumber;
        if ([self._dsh_delegate respondsToSelector:@selector(collectionView:layout:rowNumberForSectionAtIndex:)]) {
            rowNumber = [self._dsh_delegate collectionView:self.collectionView layout:self rowNumberForSectionAtIndex:section];
        }
        
        NSInteger columnNumber = _columnNumber;
        if ([self._dsh_delegate respondsToSelector:@selector(collectionView:layout:columnNumberForSectionAtIndex:)]) {
            columnNumber = [self._dsh_delegate collectionView:self.collectionView layout:self columnNumberForSectionAtIndex:section];
        }
        
        CGFloat lineSpacing = _lineSpacing;
        if ([self._dsh_delegate respondsToSelector:@selector(collectionView:layout:lineSpacingForSectionAtIndex:)]) {
            lineSpacing = [self._dsh_delegate collectionView:self.collectionView layout:self lineSpacingForSectionAtIndex:section];
        }
        
        CGFloat interitemSpacing = _interitemSpacing;
        if ([self._dsh_delegate respondsToSelector:@selector(collectionView:layout:interitemSpacingForSectionAtIndex:)]) {
            interitemSpacing = [self._dsh_delegate collectionView:self.collectionView layout:self interitemSpacingForSectionAtIndex:section];
        }
        
        CGFloat numberOfItemInPage = rowNumber * columnNumber;
        NSAssert((numberOfItemInPage > 0), @"********** DSHCollectionViewPagingLayout: 参数错误，rowNumber columnNumber 必须大于 0 **********");
        
        NSInteger numberOfItemsInSection = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
        NSInteger numberOfPageInSection = ceil(numberOfItemsInSection / numberOfItemInPage);
        
        // 计算元素宽高
        CGFloat width = (self.collectionView.frame.size.width - sectionInset.left - sectionInset.right - interitemSpacing * (columnNumber - 1)) / (float)columnNumber;
        CGFloat height = (self.collectionView.frame.size.height - sectionInset.top - sectionInset.bottom - lineSpacing * (rowNumber - 1)) / (float)rowNumber;
        
        NSMutableArray *sectionPages = [NSMutableArray arrayWithCapacity:numberOfPageInSection];
        for (int page = 0; page < numberOfPageInSection; page ++) {
            for (int i = 0; i < numberOfItemInPage; i ++) {
                NSInteger item = i + page * numberOfItemInPage;
                if (item < numberOfItemsInSection) {
                    // 创建单元属性
                    @autoreleasepool {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                        CGRect frame = attr.frame;
                        frame.size = CGSizeMake(width, height);
                        NSInteger c = i % columnNumber;
                        NSInteger r = i / columnNumber;
                        frame.origin = CGPointMake(x + sectionInset.left + c * width + c * interitemSpacing, sectionInset.top + r * height + r * lineSpacing);
                        attr.frame = frame;
                        [result addObject:attr];
                    }
                }
            }
            x += self.collectionView.frame.size.width;
            [sectionPages addObject:@(pageIndex)];
            pageIndex ++;
        }
        [self.sectionPages setObject:sectionPages forKey:@(section)];
    }
    return result;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds; {
    if (!CGSizeEqualToSize(self.collectionView.frame.size, newBounds.size)) {
        return YES;
    }
    return NO;
}

#pragma mark -
- (NSMutableDictionary <NSNumber * ,NSArray <NSNumber *>*>*)sectionPages {
    if (!_sectionPages) {
        _sectionPages = [NSMutableDictionary dictionary];
    } return _sectionPages;
}

- (id<DSHCollectionViewDelegatePagingLayout>)_dsh_delegate; {
    return (id<DSHCollectionViewDelegatePagingLayout>)self.collectionView.delegate;
}

@end

DSHCollectionViewPagingInfo DSHGetCollectionViewPagingInfo(UICollectionView *collectionView) {
    DSHCollectionViewPagingInfo result = {};
    DSHCollectionViewPagingLayout *layout = (DSHCollectionViewPagingLayout *)collectionView.collectionViewLayout;
    if ([layout isKindOfClass:[DSHCollectionViewPagingLayout class]]) {
        result.numberOfPage = ceil(collectionView.contentSize.width / collectionView.frame.size.width);
        result.currentPage = round(collectionView.contentOffset.x / collectionView.frame.size.width);
        for (NSNumber *key in layout.sectionPages.allKeys) {
            NSArray *pages = layout.sectionPages[key];
            for (NSNumber *p in pages) {
                if ([p integerValue] == result.currentPage) {
                    result.section = key.integerValue;
                    result.currentPageAtSection = [pages indexOfObject:@(result.currentPage)];
                    result.numberOfPageAtSection = pages.count;
                    return result;
                }
            }
        }
    } return result;
};
