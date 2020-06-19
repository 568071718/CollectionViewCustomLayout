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
@property (assign ,nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (assign ,nonatomic) UIOffset pageOffset;
@property (assign ,nonatomic) BOOL chooseModeSupported;
@end

NS_ASSUME_NONNULL_END
