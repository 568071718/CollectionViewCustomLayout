//
//  DSHCollectionViewCardStackLayout.h
//  CollectionViewCustomLayout
//
//  Created by 路 on 2020/6/19.
//  Copyright © 2020 路. All rights reserved.
//  卡片样式

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSHCollectionViewCardStackLayout;
@protocol DSHCollectionViewDelegateCardStackLayout <UICollectionViewDelegate>
@optional
@end

@interface DSHCollectionViewCardStackLayout : UICollectionViewLayout

@property (assign ,nonatomic) CGSize itemSize;
@property (assign ,nonatomic) UIOffset itemOffset;
@property (assign ,nonatomic) UICollectionViewScrollDirection scrollDirection;

/// 挑选模式，开启之后滑动操作只针对第一条元素，需要自己在滑动结束之后 (scrollViewDidEndDecelerating:) 处理自己的业务，默认不开启
@property (assign ,nonatomic) BOOL chooseModeSupported;
@end

NS_ASSUME_NONNULL_END
