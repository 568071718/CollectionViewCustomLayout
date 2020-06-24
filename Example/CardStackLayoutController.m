//
//  CardStackLayoutController.m
//  CollectionViewCustomLayout
//
//  Created by 路 on 2020/6/19.
//  Copyright © 2020 路. All rights reserved.
//

#import "CardStackLayoutController.h"
#import "DSHCollectionViewLayout.h"
#import "DemoUtils.h"

@interface CardStackLayoutController () <UICollectionViewDelegate ,UICollectionViewDataSource>

@property (strong ,nonatomic) UICollectionView *collectionView;
@property (strong ,nonatomic) NSMutableArray <NSDictionary *>*listData;
@end

@implementation CardStackLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    DSHCollectionViewCardStackLayout *layout = [[DSHCollectionViewCardStackLayout alloc] init];
    layout.itemSize = CGSizeMake(300, 400);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemOffset = UIOffsetMake(0, 8);
    layout.chooseModeSupported = YES;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:_collectionView];
    
    _listData = DemoUtils.listData.mutableCopy;
}

- (void)viewWillLayoutSubviews; {
    [super viewWillLayoutSubviews];
    _collectionView.frame = self.view.bounds;
}

#pragma mark -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; {
    DSHCollectionViewCardStackLayout *layout = (DSHCollectionViewCardStackLayout *)_collectionView.collectionViewLayout;
    if ([layout isKindOfClass:[DSHCollectionViewCardStackLayout class]] && !layout.chooseModeSupported) {
        return; // 调试，只有在 chooseModeSupported 等于 YES 的时候执行下面业务
    }
    
    // 取出所有正在显示的元素，如果第一条元素正在显示则不处理，如果第一条元素已经滑出屏幕，处理自身业务并执行移除操作
    NSArray *visibleItems = _collectionView.indexPathsForVisibleItems;
    for (NSIndexPath *indexPath in visibleItems) {
        if (indexPath.row == 0) {
            return;
        }
    }
    if (_listData.count > 0) {
        // 这里拿到当次滑动的数据，根据自身业务做处理
        NSDictionary *rowData = _listData.firstObject;
        // 判断方向
        CGPoint contentOffset = scrollView.contentOffset;
        if (layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            if (contentOffset.x > scrollView.bounds.size.width) {
                NSLog(@"加入喜欢列表: (%@)" ,rowData);
            } else if (contentOffset.x < scrollView.bounds.size.width) {
                NSLog(@"不感兴趣: (%@)" ,rowData);
            }
        } else if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            if (contentOffset.y > scrollView.bounds.size.height) {
                NSLog(@"加入喜欢列表: (%@)" ,rowData);
            } else if (contentOffset.y < scrollView.bounds.size.height) {
                NSLog(@"不感兴趣: (%@)" ,rowData);
            }
        }
        // 移除本次滑动的数据
        [_listData removeObject:rowData];
        [_collectionView reloadData];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView; {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section; {
    return _listData.count;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    cell.contentView.layer.cornerRadius = 10.0f;
    cell.contentView.layer.masksToBounds =YES;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    cell.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:.2].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0,2);
    cell.layer.shadowRadius = 10.f;
    cell.layer.shadowOpacity = .5;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    UIImageView *imageView = [cell.contentView viewWithTag:10];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithImage:nil];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = 10;
        [cell.contentView addSubview:imageView];
    }
    imageView.frame = cell.bounds;
    NSDictionary *rowData = _listData[indexPath.row];
    [DemoUtils setImageURL:[NSURL URLWithString:rowData[@"content"]] forImageView:imageView];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
    NSLog(@"%@" ,[NSString stringWithFormat:@"%@-%@" ,@(indexPath.section) ,@(indexPath.row)]);
}

@end
