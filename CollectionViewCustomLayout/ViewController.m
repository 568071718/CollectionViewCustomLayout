//
//  ViewController.m
//  CollectionViewCustomLayout
//
//  Created by 路 on 2019/3/13.
//  Copyright © 2019年 路. All rights reserved.
//

#import "ViewController.h"
#import "PagingLayoutController.h"
#import "WaterfallFlowLayoutController.h"
#import "CardStackLayoutController.h"

static NSString *const PAGINGLAYOUT = @"PAGINGLAYOUT";
static NSString *const WATERFALLFLOWLAYOUT = @"WATERFALLFLOWLAYOUT";
static NSString *const CARDSTACKLAYOUT = @"CARDSTACKLAYOUT";

@interface ViewController () <UITableViewDelegate ,UITableViewDataSource>

@property (strong ,nonatomic) UITableView *tableView;
@property (strong ,nonatomic) NSArray <NSString *>*listData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 200)];
    tableHeaderView.backgroundColor = [UIColor lightGrayColor];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = tableHeaderView;
    [self.view addSubview:_tableView];
    
    _listData = @[PAGINGLAYOUT,WATERFALLFLOWLAYOUT,CARDSTACKLAYOUT];
    [_tableView reloadData];
}

- (void)viewWillLayoutSubviews; {
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test_cell"];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.text = _listData[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *rowData = _listData[indexPath.row];
    if (rowData == PAGINGLAYOUT) {
        PagingLayoutController *vc = [[PagingLayoutController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (rowData == WATERFALLFLOWLAYOUT) {
        WaterfallFlowLayoutController *vc = [[WaterfallFlowLayoutController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (rowData == CARDSTACKLAYOUT) {
        CardStackLayoutController *vc = [[CardStackLayoutController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
