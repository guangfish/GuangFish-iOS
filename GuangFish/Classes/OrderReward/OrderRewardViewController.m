//
//  OrderRewardViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "OrderRewardViewController.h"
#import "MJRefresh.h"
#import "OrderRewardCell.h"

@interface OrderRewardViewController ()<BaseVCManager>

@end

@implementation OrderRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self initialzieModel];
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [self.viewModel loadNextPageOrderRewardList];
    }];
    [footer setTitle:@"" forState:(MJRefreshStateNoMoreData)];
    [footer setTitle:@"" forState:(MJRefreshStateIdle)];
    self.tableView.mj_footer = footer;
    
    [self.viewModel reloadOrderRewardList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BaseVCManager

- (UIView*)nodataView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 149) / 2.0, -100, 149, 136)];
    imageView.image = [UIImage imageNamed:@"img_nodd"];
    return imageView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.orderRewardCellVMList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderRewardCell" forIndexPath:indexPath];
    
    OrderRewardCellVM *orderRewardCellVM = [self.viewModel.orderRewardCellVMList objectAtIndex:indexPath.row];
    cell.viewModel = orderRewardCellVM;
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private methods

- (void)initialzieModel {
    @weakify(self);
    [self.viewModel.requestGetOrderRewardSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([self.viewModel.haveMore boolValue]) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - getters and setters

- (OrderRewardVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [OrderRewardVM new];
    }
    return _viewModel;
}

@end
