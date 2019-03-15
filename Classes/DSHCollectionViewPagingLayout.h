//
//  DSHCollectionViewPagingLayout.h
//  DSHCollectionViewPagingLayout
//
//  Created by 路 on 2019/3/12.
//  Copyright © 2019年 路. All rights reserved.
//  UICollectionView 横向分页自定义layout
//  https://github.com/568071718/CollectionViewCustomLayout

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSHCollectionViewPagingLayout;

typedef struct {
    NSInteger currentPage ,numberOfPage;
    NSInteger section ,currentPageAtSection ,numberOfPageAtSection;
} DSHCollectionViewPagingInfo;
UIKIT_EXTERN DSHCollectionViewPagingInfo DSHGetCollectionViewPagingInfo(UICollectionView *collectionView);
UIKIT_EXTERN void DSHCollectionViewScrollToIndexPath(UICollectionView *collectionView ,NSIndexPath *indexPath ,BOOL animated); // 滚动至 indexPath 所处页

@protocol DSHCollectionViewDelegatePagingLayout <UICollectionViewDelegate>
@optional
/**
 * 提供针对不同 section 设置不同属性值的接口，用法同 UICollectionViewDelegateFlowLayout
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(DSHCollectionViewPagingLayout *)collectionViewLayout rowNumberForSectionAtIndex:(NSInteger)section;
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(DSHCollectionViewPagingLayout *)collectionViewLayout columnNumberForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(DSHCollectionViewPagingLayout *)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(DSHCollectionViewPagingLayout *)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(DSHCollectionViewPagingLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
@end

@interface DSHCollectionViewPagingLayout : UICollectionViewLayout

/// 每页行数
@property (assign ,nonatomic) NSInteger rowNumber;

/// 每页列数
@property (assign ,nonatomic) NSInteger columnNumber;

/// 行间距
@property (assign ,nonatomic) CGFloat lineSpacing;

/// 列间距
@property (assign ,nonatomic) CGFloat interitemSpacing;

/// 边距
@property (assign ,nonatomic) UIEdgeInsets sectionInset;
@end

NS_ASSUME_NONNULL_END
