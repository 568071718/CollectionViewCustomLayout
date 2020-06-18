//
//  DSHCollectionViewPagingLayout.h
//  DSHCollectionViewPagingLayout
//
//  Created by 路 on 2019/3/12.
//  Copyright © 2019年 路. All rights reserved.
//  UICollectionView 横向分页自定义layout
//  https://github.com/568071718/CollectionViewCustomLayout
//  --------------------- ---------------------
//  |    0    1    2    | |    6    7    8    |
//  --------------------- ---------------------
//  |    3    4    5    | |    9    10   11   |
//  --------------------- ---------------------

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSHCollectionViewPagingLayout;

typedef struct {
    
    /// 当前所处分区
    NSUInteger section;
    
    /// 当前所处第几页 (相对于所有分页)
    NSUInteger currentPage;
    /// 当前所处第几页 (相对于当前分区)
    NSUInteger currentPageAtSection;
    
    /// 一共有多少页内容 (所有分页)
    NSUInteger numberOfPage;
    /// 一共有多少页内容 (相对于当前分区)
    NSUInteger numberOfPageAtSection;
    
} DSHCollectionViewPagingInfo;

UIKIT_EXTERN DSHCollectionViewPagingInfo DSHGetCollectionViewPagingInfo(UICollectionView *collectionView);
UIKIT_EXTERN void DSHCollectionViewScrollToIndexPath(UICollectionView *collectionView ,NSIndexPath *indexPath ,BOOL animated) DEPRECATED_MSG_ATTRIBUTE("使用 [UICollectionView scrollToItemAtIndexPath:atScrollPosition:animated:] 方法代替"); // 滚动至 indexPath 所处页

@protocol DSHCollectionViewDelegatePagingLayout <UICollectionViewDelegate>
@optional
/// 提供针对不同 section 设置不同属性值的接口，用法同 UICollectionViewDelegateFlowLayout
- (NSInteger)pagingLayout:(DSHCollectionViewPagingLayout *)pagingLayout collectionView:(UICollectionView *)collectionView rowNumberForSectionAtIndex:(NSInteger)section;
- (NSInteger)pagingLayout:(DSHCollectionViewPagingLayout *)pagingLayout collectionView:(UICollectionView *)collectionView columnNumberForSectionAtIndex:(NSInteger)section;
- (CGFloat)pagingLayout:(DSHCollectionViewPagingLayout *)pagingLayout collectionView:(UICollectionView *)collectionView lineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)pagingLayout:(DSHCollectionViewPagingLayout *)pagingLayout collectionView:(UICollectionView *)collectionView interitemSpacingForSectionAtIndex:(NSInteger)section;
- (UIEdgeInsets)pagingLayout:(DSHCollectionViewPagingLayout *)pagingLayout collectionView:(UICollectionView *)collectionView insetForSectionAtIndex:(NSInteger)section;
@end

@interface DSHCollectionViewPagingLayout : UICollectionViewLayout

// 布局属性
@property (assign ,nonatomic) NSInteger rowNumber;
@property (assign ,nonatomic) NSInteger columnNumber;
@property (assign ,nonatomic) CGFloat lineSpacing;
@property (assign ,nonatomic) CGFloat interitemSpacing;
@property (assign ,nonatomic) UIEdgeInsets sectionInset;

// 计算当前分页信息
@property (readonly) DSHCollectionViewPagingInfo pagingInfo;
@end

NS_ASSUME_NONNULL_END
