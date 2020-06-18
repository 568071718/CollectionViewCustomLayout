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
/// 返回元素的高度
- (CGFloat)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;
@end

@interface DSHCollectionViewWaterfallFlowLayout : UICollectionViewLayout

@property (assign ,nonatomic) NSInteger columnNumber;
@property (assign ,nonatomic) CGFloat itemHeight;
@property (assign ,nonatomic) CGFloat lineSpacing;
@property (assign ,nonatomic) CGFloat interitemSpacing;
@property (assign ,nonatomic) UIEdgeInsets sectionInset;
@end

NS_ASSUME_NONNULL_END
