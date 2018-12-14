//
//  HotSellingViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/16.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HotSellingViewController.h"
#import "HotSellingCell.h"
#import "MBProgressHUD.h"
#import "NavMenuView.h"

@interface HotSellingViewController ()<NavMenuViewDelegate>

@property (nonatomic, assign) BOOL menuIsOpen;
@property (nonatomic, strong) NavMenuView *navMenuView;

@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (weak, nonatomic) IBOutlet UIImageView *menuImageView;
- (IBAction)menuBtnAction:(id)sender;

@end

@implementation HotSellingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuIsOpen = NO;
    [self.navigationController.view addSubview:self.navMenuView];
    
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
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.title = @"热卖";
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

#pragma mark - NavMenuViewDelegate

- (void)navMenuViewSelected:(NSString *)name {
    [self menuBtnAction:nil];
    self.menuLabel.text = name;
    self.viewModel.key = name;
    [self.tableView.mj_header beginRefreshing];
    [self.tableView reloadData];
    self.title = @"热卖";
}

- (void)navMenuViewClose {
    self.menuIsOpen = NO;
    self.menuImageView.image = [UIImage imageNamed:@"img_menu_enter2"];
    self.navMenuView.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - events

- (IBAction)menuBtnAction:(id)sender {
    self.menuIsOpen = !self.menuIsOpen;
    if (self.menuIsOpen) {
        self.menuImageView.image = [UIImage imageNamed:@"img_menu_enter"];
        self.navMenuView.hidden = NO;
        self.tabBarController.tabBar.hidden = YES;
    } else {
        self.menuImageView.image = [UIImage imageNamed:@"img_menu_enter2"];
        self.navMenuView.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    }
}

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

- (void)showActivityHudByText:(NSString*)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = text;
}

- (void)hideActivityHud {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - setters and getters

- (HotSellingVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[HotSellingVM alloc] init];
    }
    return _viewModel;
}

- (NavMenuView*)navMenuView {
    if (_navMenuView == nil) {
        self.navMenuView = [[NavMenuView alloc] initWithFrame:CGRectMake(0, NaviHeight, self.view.frame.size.width, self.view.frame.size.height)];
        self.navMenuView.hidden = YES;
        self.navMenuView.delegate = self;
    }
    return _navMenuView;
}

@end
