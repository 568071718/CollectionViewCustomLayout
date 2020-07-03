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
@property (strong ,nonatomic) NSMutableDictionary *heightCache;
@end

@implementation WaterfallFlowLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _heightCache = [NSMutableDictionary dictionary];
    
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
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.view addSubview:_collectionView];
    
    _listData = DemoUtils.listData;
}

- (void)viewWillLayoutSubviews; {
    [super viewWillLayoutSubviews];
    _collectionView.frame = self.view.bounds;
}

#pragma mark -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView; {
    return 3;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath; {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        view.backgroundColor = [UIColor brownColor];
        NSInteger tag = 28;
        UILabel *label = [view viewWithTag:tag];
        if (!label) {
            label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.tag = tag;
            [view addSubview:label];
        }
        label.frame = view.bounds;
        label.text = [NSString stringWithFormat:@"区头(%@)" ,@(indexPath.section)];
        return view;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        view.backgroundColor = [UIColor orangeColor];
        NSInteger tag = 28;
        UILabel *label = [view viewWithTag:tag];
        if (!label) {
            label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.tag = tag;
            [view addSubview:label];
        }
        label.frame = view.bounds;
        label.text = [NSString stringWithFormat:@"区尾(%@)" ,@(indexPath.section)];
        return view;
    }
    return nil;
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

#pragma mark - DSHCollectionViewDelegateWaterfallFlowLayout 可选实现
/// 瀑布流需要分成多少列
- (NSInteger)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView numberOfColumnAtSection:(NSInteger)section; {
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return 2;
    }
    if (section == 2) {
        return 4;
    }
    return 2;
}

/// 区头高度
- (CGFloat)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView heightForHeaderInSection:(NSInteger)section; {
    return 44.f;
}

/// 区尾高度
- (CGFloat)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView heightForFooterInSection:(NSInteger)section; {
    if (section == 2) {
        return 44.f;
    }
    return 0.f;
}

/// 行间距
- (CGFloat)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView spacingForLineAtSection:(NSInteger)section; {
    return waterfallFlowLayout.lineSpacing;
}

// 元素之间间距
- (CGFloat)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView spacingForItemAtSection:(NSInteger)section; {
    return waterfallFlowLayout.interitemSpacing;
}

// 边距
- (UIEdgeInsets)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView sectionInsetAtSection:(NSInteger)section; {
    return waterfallFlowLayout.sectionInset;
}

/// 返回元素的高度
- (CGFloat)waterfallFlowLayout:(DSHCollectionViewWaterfallFlowLayout *)waterfallFlowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth; {
    NSString *key = [NSString stringWithFormat:@"%@_%@" ,@(indexPath.section) ,@(indexPath.row)];
    NSNumber *height = [_heightCache objectForKey:key];
    if (!height) {
        height = @(arc4random() % 300 + 100);
        [_heightCache setObject:height forKey:key]; // 实际应用中也应该是每条数据对应一个固定的高度
    }
    return height.floatValue;
}
@end
