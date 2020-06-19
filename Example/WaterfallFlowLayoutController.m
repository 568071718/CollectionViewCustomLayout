//
//  WaterfallFlowLayoutController.m
//  CollectionViewCustomLayout
//
//  Created by 路 on 2020/6/19.
//  Copyright © 2020 路. All rights reserved.
//

#import "WaterfallFlowLayoutController.h"
#import "DSHCollectionViewLayout.h"

@interface WaterfallFlowLayoutController () <DSHCollectionViewDelegateWaterfallFlowLayout ,UICollectionViewDataSource>

@property (strong ,nonatomic) UICollectionView *collectionView;

@end

@implementation WaterfallFlowLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Do any additional setup after loading the view.
    DSHCollectionViewWaterfallFlowLayout *layout = [[DSHCollectionViewWaterfallFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.lineSpacing = 10.f;
    layout.interitemSpacing = 10.f;
    layout.columnNumber = 3;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
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
    return 50;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor brownColor];
    CGFloat r = arc4random() % 255 / 255.f ,g = arc4random() % 255 / 255.f ,b = arc4random() % 255 / 255.f;
    cell.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
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
/// 返回元素的高度
- (CGFloat)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth; {
    return arc4random() % 300 + 100;
}
@end
