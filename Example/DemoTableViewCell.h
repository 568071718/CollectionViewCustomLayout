//
//  DemoTableViewCell.h
//  CollectionViewCustomLayout
//
//  Created by 路 on 2019/3/13.
//  Copyright © 2019年 路. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSHCollectionViewLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface DemoTableViewCell : UITableViewCell <DSHCollectionViewDelegatePagingLayout ,UICollectionViewDataSource>

@property (strong ,nonatomic) UIPageControl *pageControl;
@property (strong ,nonatomic) UICollectionView *collectionView;
@end

NS_ASSUME_NONNULL_END
