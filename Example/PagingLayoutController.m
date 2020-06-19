//
//  PagingLayoutController.m
//  CollectionViewCustomLayout
//
//  Created by 路 on 2020/6/19.
//  Copyright © 2020 路. All rights reserved.
//

#import "PagingLayoutController.h"
#import "DSHCollectionViewLayout.h"

@interface PagingLayoutController () <DSHCollectionViewDelegatePagingLayout ,UICollectionViewDataSource>

@property (strong ,nonatomic) UICollectionView *collectionView;
@end

@implementation PagingLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    DSHCollectionViewPagingLayout *layout = [[DSHCollectionViewPagingLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(200, 10, 200, 10);
    layout.lineSpacing = 10.f;
    layout.interitemSpacing = 10.f;
    layout.rowNumber = 3;
    layout.columnNumber = 4;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:_collectionView];
}

- (void)viewWillLayoutSubviews; {
    [super viewWillLayoutSubviews];
    _collectionView.frame = self.view.bounds;
}


#pragma mark -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView; {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section; {
    return 20;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor brownColor];
    UILabel *label = [cell viewWithTag:10];
    if (!label) {
        label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.tag = 10;
        label.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:label];
    }
    label.frame = cell.bounds;
    label.text = [NSString stringWithFormat:@"%@-%@" ,@(indexPath.section) ,@(indexPath.row)];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
    NSLog(@"%@" ,[NSString stringWithFormat:@"%@-%@" ,@(indexPath.section) ,@(indexPath.row)]);
}
@end
