//
//  WaterfallFlowLayoutController.m
//  CollectionViewCustomLayout
//
//  Created by 路 on 2020/6/19.
//  Copyright © 2020 路. All rights reserved.
//

#import "WaterfallFlowLayoutController.h"
#import "DSHCollectionViewLayout.h"
#import "DemoUtils.h"

@interface WaterfallFlowLayoutController () <DSHCollectionViewDelegateWaterfallFlowLayout ,UICollectionViewDataSource>

@property (strong ,nonatomic) UICollectionView *collectionView;
@property (strong ,nonatomic) NSArray <NSDictionary *>*listData;
@end

@implementation WaterfallFlowLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DSHCollectionViewWaterfallFlowLayout *layout = [[DSHCollectionViewWaterfallFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.lineSpacing = 5.f;
    layout.interitemSpacing = 5.f;
    layout.columnNumber = 2;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:_collectionView];
    
    _listData = DemoUtils.listData;
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
    return _listData.count;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 5.f;
    cell.layer.masksToBounds = YES;
    
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
/// 返回元素的高度
- (CGFloat)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth; {
    return arc4random() % 300 + 100;
}
@end
