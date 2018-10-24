//
//  HotSellingViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/16.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HotSellingViewController.h"
#import "MJRefresh.h"
#import "HotSellingCell.h"

@interface HotSellingViewController ()

@end

@implementation HotSellingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialzieModel];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self showActivityHudByText:@""];
        [self.viewModel reloadHotSellingList];
    }];
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [self showActivityHudByText:@""];
        [self.viewModel loadNextPageHotSellingList];
    }];
    [footer setTitle:@"" forState:(MJRefreshStateNoMoreData)];
    [footer setTitle:@"" forState:(MJRefreshStateIdle)];
    self.tableView.mj_footer = footer;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.hotSellingCellVMList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotSellingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotSellingCell" forIndexPath:indexPath];
    
    HotSellingCellVM *hotSellingCellVM = [self.viewModel.hotSellingCellVMList objectAtIndex:indexPath.row];
    cell.viewModel = hotSellingCellVM;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HotSellingCellVM *hotSellingCellVM = [self.viewModel.hotSellingCellVMList objectAtIndex:indexPath.row];
    [hotSellingCellVM openTaobao];
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
    RAC(self, title) = RACObserve(self.viewModel, key);
    
    @weakify(self);
    [self.viewModel.requestGetProductSearchSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        [self.tableView.mj_header endRefreshing];
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

#pragma mark - setters and getters

- (HotSellingVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[HotSellingVM alloc] init];
    }
    return _viewModel;
}

@end
