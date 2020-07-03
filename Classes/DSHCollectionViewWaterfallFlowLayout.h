//
//  DSHCollectionViewWaterfallFlowLayout.h
//  CollectionViewCustomLayout
//
//  Created by 路 on 2020/6/18.
//  Copyright © 2020 路. All rights reserved.
//  https://github.com/568071718/CollectionViewCustomLayout
//  瀑布流效果

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSHCollectionViewWaterfallFlowLayout;
@protocol DSHCollectionViewDelegateWaterfallFlowLayout <UICollectionViewDelegate>
@optional
/// 瀑布流需要分成多少列显示
- (NSInteger)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView numberOfColumnAtSection:(NSInteger)section;

/// 区头高度
- (CGFloat)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView heightForHeaderInSection:(NSInteger)section;

/// 区尾高度
- (CGFloat)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView heightForFooterInSection:(NSInteger)section;

/// 行间距
- (CGFloat)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView spacingForLineAtSection:(NSInteger)section;

/// 元素之间间距
- (CGFloat)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView spacingForItemAtSection:(NSInteger)section;

/// 边距
- (UIEdgeInsets)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView sectionInsetAtSection:(NSInteger)section;

/// 返回元素的高度
- (CGFloat)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;
@end

@interface DSHCollectionViewWaterfallFlowLayout : UICollectionViewLayout

@property (assign ,nonatomic) NSInteger columnNumber;
@property (assign ,nonatomic) CGFloat itemHeight;
@property (assign ,nonatomic) CGFloat lineSpacing;
@property (assign ,nonatomic) CGFloat interitemSpacing;
@property (assign ,nonatomic) UIEdgeInsets sectionInset;

@property (assign ,nonatomic) BOOL sectionHeadersPinToVisibleBounds;
@property (assign ,nonatomic) BOOL sectionFootersPinToVisibleBounds;
@end

NS_ASSUME_NONNULL_END
