//
//  CardStackLayoutController.m
//  CollectionViewCustomLayout
//
//  Created by 路 on 2020/6/19.
//  Copyright © 2020 路. All rights reserved.
//

#import "CardStackLayoutController.h"
#import "DSHCollectionViewLayout.h"

@interface CardStackLayoutController () <UICollectionViewDelegate ,UICollectionViewDataSource>

@property (strong ,nonatomic) UICollectionView *collectionView;
@property (strong ,nonatomic) NSMutableArray <NSString *>*listData;
@end

@implementation CardStackLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    DSHCollectionViewCardStackLayout *layout = [[DSHCollectionViewCardStackLayout alloc] init];
    layout.itemSize = CGSizeMake(300, 300);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.pageOffset = UIOffsetMake(0, 8);
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
    
    _listData = @[@"还是",@"服务呢看",@"票据法满五年",@"访问方面呢",@"破你们",@"微服务",@"和午饭后"].mutableCopy;
}

- (void)viewWillLayoutSubviews; {
    [super viewWillLayoutSubviews];
    _collectionView.frame = self.view.bounds;
}

#pragma mark -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; {
    NSArray *visibleItems = _collectionView.indexPathsForVisibleItems;
    for (NSIndexPath *indexPath in visibleItems) {
        if (indexPath.row == 0) {
            return;
        }
    }
    if (_listData.count > 0) {
        id rowData = _listData.firstObject;
        // 判断方向
        CGPoint contentOffset = scrollView.contentOffset;
        if (contentOffset.x > scrollView.bounds.size.width) {
            NSLog(@"加入喜欢列表: (%@)" ,rowData);
        } else if (contentOffset.x < scrollView.bounds.size.width) {
            NSLog(@"不感兴趣: (%@)" ,rowData);
        }
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
    
    UILabel *label = [cell viewWithTag:10];
    if (!label) {
        label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.tag = 10;
        label.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:label];
    }
    label.frame = cell.bounds;
    label.text = [NSString stringWithFormat:@"%@" ,_listData[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
    NSLog(@"%@" ,[NSString stringWithFormat:@"%@-%@" ,@(indexPath.section) ,@(indexPath.row)]);
}

@end
