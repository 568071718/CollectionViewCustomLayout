//
//  DSHCollectionViewPagingLayout.m
//  DSHCollectionViewPagingLayout
//
//  Created by 路 on 2019/3/12.
//  Copyright © 2019年 路. All rights reserved.
//

#import "DSHCollectionViewPagingLayout.h"

@interface DSHCollectionViewPagingLayout ()
@property (strong ,nonatomic) NSArray <NSDictionary *>*sectionPageInfos;
@end

@implementation DSHCollectionViewPagingLayout {
    NSArray <UICollectionViewLayoutAttributes *>*_layoutAttributes;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    } return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    _rowNumber = 1;
    _columnNumber = 1;
}

- (void)prepareLayout; {
    [super prepareLayout];
    
    NSMutableArray <UICollectionViewLayoutAttributes *>*result = [NSMutableArray array];
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    CGFloat x = 0;
    NSInteger pageIndex = 0;
    NSMutableArray *sectionPageInfos = [NSMutableArray arrayWithCapacity:numberOfSections];
    for (int section = 0; section < numberOfSections; section ++) {
        
        UIEdgeInsets sectionInset = _sectionInset;
        if ([self._dsh_delegate respondsToSelector:@selector(pagingLayout:collectionView:insetForSectionAtIndex:)]) {
            sectionInset = [self._dsh_delegate pagingLayout:self collectionView:self.collectionView insetForSectionAtIndex:section];
        }
        
        NSInteger rowNumber = _rowNumber;
        if ([self._dsh_delegate respondsToSelector:@selector(pagingLayout:collectionView:rowNumberForSectionAtIndex:)]) {
            rowNumber = [self._dsh_delegate pagingLayout:self collectionView:self.collectionView rowNumberForSectionAtIndex:section];
        }
        
        NSInteger columnNumber = _columnNumber;
        if ([self._dsh_delegate respondsToSelector:@selector(pagingLayout:collectionView:columnNumberForSectionAtIndex:)]) {
            columnNumber = [self._dsh_delegate pagingLayout:self collectionView:self.collectionView columnNumberForSectionAtIndex:section];
        }
        
        CGFloat lineSpacing = _lineSpacing;
        if ([self._dsh_delegate respondsToSelector:@selector(pagingLayout:collectionView:lineSpacingForSectionAtIndex:)]) {
            lineSpacing = [self._dsh_delegate pagingLayout:self collectionView:self.collectionView lineSpacingForSectionAtIndex:section];
        }
        
        CGFloat interitemSpacing = _interitemSpacing;
        if ([self._dsh_delegate respondsToSelector:@selector(pagingLayout:collectionView:interitemSpacingForSectionAtIndex:)]) {
            interitemSpacing = [self._dsh_delegate pagingLayout:self collectionView:self.collectionView interitemSpacingForSectionAtIndex:section];
        }
        // 当前区域每页可以展示多少条数据
        CGFloat numberOfItemInPage = rowNumber * columnNumber;
        NSAssert((numberOfItemInPage > 0), @"********** DSHCollectionViewPagingLayout: 参数错误，rowNumber columnNumber 必须大于 0 **********");
        // 当前区域一共有多少条数据
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        // 当前区域所有数据一共需要占多少页
        NSInteger numberOfPageInSection = ceil(numberOfItemsInSection / numberOfItemInPage);
        // 计算元素宽高
        CGFloat width = (self.collectionView.frame.size.width - sectionInset.left - sectionInset.right - interitemSpacing * (columnNumber - 1)) / (float)columnNumber;
        CGFloat height = (self.collectionView.frame.size.height - sectionInset.top - sectionInset.bottom - lineSpacing * (rowNumber - 1)) / (float)rowNumber;
        
        // 创建一个数组，用来保存当前区域所占用到的页码
        NSMutableArray *sectionPages = [NSMutableArray arrayWithCapacity:numberOfPageInSection];
        // 创建一个字典把当前分区跟分区所占页码关联起来
        NSMutableDictionary *sectionPageInfo = @{@"section":@(section),@"pages":sectionPages}.mutableCopy;
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
        [sectionPageInfos addObject:sectionPageInfo];
    }
    _sectionPageInfos = [sectionPageInfos copy];
    _layoutAttributes = result.copy;
}

#pragma mark - Every layout object should implement the following methods
- (CGSize)collectionViewContentSize {
    // 遍历所有元素，找到最右边的元素的位置就是自身容器的宽度
    CGSize result = self.collectionView.bounds.size;
    for (UICollectionViewLayoutAttributes *attr in _layoutAttributes) {
        result.width = MAX(result.width, CGRectGetMaxX(attr.frame));
    }
    // 补上 section inset 右边距
    UIEdgeInsets sectionInset = _sectionInset;
    if ([self._dsh_delegate respondsToSelector:@selector(pagingLayout:collectionView:insetForSectionAtIndex:)]) {
        sectionInset = [self._dsh_delegate pagingLayout:self collectionView:self.collectionView insetForSectionAtIndex:self.collectionView.numberOfSections - 1];
    }
    result.width = result.width + sectionInset.right;
    return result;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _layoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds; {
    if (!CGSizeEqualToSize(self.collectionView.frame.size, newBounds.size)) {
        return YES;
    }
    return NO;
}

#pragma mark -
- (id<DSHCollectionViewDelegatePagingLayout>)_dsh_delegate; {
    return (id<DSHCollectionViewDelegatePagingLayout>)self.collectionView.delegate;
}

- (DSHCollectionViewPagingInfo)pagingInfo; {
    UICollectionView *collectionView = self.collectionView;
    if (collectionView.frame.size.width <= 0) return (DSHCollectionViewPagingInfo){0};
    DSHCollectionViewPagingInfo result = {0};
    result.numberOfPage = ceil(collectionView.contentSize.width / collectionView.frame.size.width);
    result.currentPage = round(collectionView.contentOffset.x / collectionView.frame.size.width);
    for (NSDictionary *sectionPageInfo in _sectionPageInfos) {
        NSArray <NSNumber *>*pages = sectionPageInfo[@"pages"];
        for (NSNumber *pageIndex in pages) {
            if (pageIndex.integerValue == result.currentPage) {
                result.section = [sectionPageInfo[@"section"] integerValue];
                result.currentPageAtSection = [pages indexOfObject:pageIndex];
                result.numberOfPageAtSection = pages.count;
                return result;
            }
        }
    }
    return result;
}

@end

DSHCollectionViewPagingInfo DSHGetCollectionViewPagingInfo(UICollectionView *collectionView) {
    DSHCollectionViewPagingLayout *layout = (DSHCollectionViewPagingLayout *)collectionView.collectionViewLayout;
    if ([layout isKindOfClass:[DSHCollectionViewPagingLayout class]]) {
        return layout.pagingInfo;
    } return (DSHCollectionViewPagingInfo){0};
};
void DSHCollectionViewScrollToIndexPath(UICollectionView *collectionView ,NSIndexPath *indexPath ,BOOL animated) {
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
};

