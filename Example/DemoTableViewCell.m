//
//  DemoTableViewCell.m
//  CollectionViewCustomLayout
//
//  Created by 路 on 2019/3/13.
//  Copyright © 2019年 路. All rights reserved.
//

#import "DemoTableViewCell.h"

@implementation DemoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        DSHCollectionViewPagingLayout *layout = [[DSHCollectionViewPagingLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
        layout.lineSpacing = 3;
        layout.interitemSpacing = 3;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [self addSubview:_collectionView];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.userInteractionEnabled = NO;
        [self addSubview:_pageControl];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollViewDidScroll:self.collectionView];
        });
    } return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _pageControl.frame = CGRectMake(0, self.frame.size.height - 44.f, self.frame.size.width, 44.f);
}

#pragma mark - scroll view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    DSHCollectionViewPagingInfo info = DSHGetCollectionViewPagingInfo(_collectionView);
    _pageControl.numberOfPages = info.numberOfPageAtSection;
    _pageControl.currentPage = info.currentPageAtSection;
    _pageControl.hidden = (_pageControl.numberOfPages <= 1);
}

#pragma mark - collection view
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section; {
    if (section == 0) {
        return 14;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 15;
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UILabel *label = [cell viewWithTag:45];
    if (!label) {
        label = [[UILabel alloc] init];
        label.tag = 45;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [cell addSubview:label];
    }
    label.frame = cell.bounds;
    label.text = [NSString stringWithFormat:@"%@" ,@(indexPath.row)];
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor orangeColor];
    } else if (indexPath.section == 1) {
        cell.backgroundColor = [UIColor cyanColor];
    } else if (indexPath.section == 2) {
        cell.backgroundColor = [UIColor brownColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@ - %@" ,@(indexPath.section) ,@(indexPath.row));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(DSHCollectionViewPagingLayout *)collectionViewLayout rowNumberForSectionAtIndex:(NSInteger)section; {
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(DSHCollectionViewPagingLayout *)collectionViewLayout columnNumberForSectionAtIndex:(NSInteger)section; {
    if (section == 0) {
        return 4;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 3;
    }
    return 1;
}

@end
