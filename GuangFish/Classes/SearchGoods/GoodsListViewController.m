//
//  GoodsListViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/25.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface GoodsListViewController ()

@property (nonatomic, strong) MBProgressHUD *autoShowGoodsHUD;

@end

@implementation GoodsListViewController {
    dispatch_source_t _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self initialzieModel];
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [self showActivityHudByText:@""];
        [self.viewModel loadNextPageGoodsList];
    }];
    [footer setTitle:@"" forState:(MJRefreshStateNoMoreData)];
    [footer setTitle:@"" forState:(MJRefreshStateIdle)];
    self.tableView.mj_footer = footer;
    
    [self reloadData];
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
    if ([self.viewModel needAutoShowGoods] && self.isViewLoaded && self.view.window) {
        [self beginAutoShowHUD];
    }
    return self.viewModel.goodsListCellVMList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCell" forIndexPath:indexPath];
    
    GoodsCellVM *goodsCellVM = [self.viewModel.goodsListCellVMList objectAtIndex:indexPath.row];
    cell.viewModel = goodsCellVM;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
    }
    [self.autoShowGoodsHUD hideAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsCellVM *goodsCellVM = [self.viewModel.goodsListCellVMList objectAtIndex:indexPath.row];
    if (self.viewModel.isTaobao) {
        [goodsCellVM openTaobao];
    } else {
        [goodsCellVM openSafari];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - public methods

- (void)reloadData {
    [self.viewModel reloadGoodsList];
    [self showActivityHudByText:@""];
}

#pragma mark - private methods

- (void)initialzieModel {
    @weakify(self);
    [self.viewModel.requestGetGoodsListSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
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

- (void)beginAutoShowHUD {
    self.autoShowGoodsHUD = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    self.autoShowGoodsHUD.mode = MBProgressHUDModeText;
    self.autoShowGoodsHUD.userInteractionEnabled = NO;
    
    __block NSInteger num = 6;
    if (self.viewModel.isTaobao) {
        self.autoShowGoodsHUD.label.text = [NSString stringWithFormat:@"%ld秒钟后自动打开淘宝", (long)num];
    } else {
        self.autoShowGoodsHUD.label.text = [NSString stringWithFormat:@"%ld秒钟后自动跳转到京东", (long)num];
    }
    [self.autoShowGoodsHUD showAnimated:YES];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (num <= 0) {
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.autoShowGoodsHUD hideAnimated:YES];
                [self.viewModel autoShowGoods];
            });
        } else {
            num --;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.viewModel.isTaobao) {
                    self.autoShowGoodsHUD.label.text = [NSString stringWithFormat:@"%ld秒钟后自动打开淘宝", (long)num];
                } else {
                    self.autoShowGoodsHUD.label.text = [NSString stringWithFormat:@"%ld秒钟后自动跳转到京东", (long)num];
                }
            });
        }
    });
    dispatch_resume(_timer);
}

- (void)showActivityHudByText:(NSString*)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = text;
}

- (void)hideActivityHud {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - getters and setters

- (GoodsListVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [GoodsListVM new];
    }
    return _viewModel;
}

@end
