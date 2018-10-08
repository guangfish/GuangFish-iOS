//
//  FriendsListViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/26.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "FriendsListViewController.h"
#import "MJRefresh.h"
#import "FriendCell.h"

@interface FriendsListViewController ()

@end

@implementation FriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self initialzieModel];
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [self.viewModel loadNextPageFriendsList];
    }];
    [footer setTitle:@"" forState:(MJRefreshStateNoMoreData)];
    [footer setTitle:@"" forState:(MJRefreshStateIdle)];
    self.tableView.mj_footer = footer;
    
    [self.viewModel reloadFriendsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.friendCellVMList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    
    FriendCellVM *friendCellVM = [self.viewModel.friendCellVMList objectAtIndex:indexPath.row];
    cell.viewModel = friendCellVM;
    
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
    [self.viewModel.requestGetFriendsSignal subscribeNext:^(id  _Nullable x) {
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

- (FriendsListVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [FriendsListVM new];
    }
    return _viewModel;
}

@end
