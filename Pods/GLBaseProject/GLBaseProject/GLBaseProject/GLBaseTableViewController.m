//
//  BaseTableViewController.m
//  CheFu
//
//  Created by gulu on 15/8/12.
//  Copyright (c) 2015年 lianan. All rights reserved.
//

#import "GLBaseTableViewController.h"
#import "MBProgressHUD.h"
#import "GLViewModel.h"
#import <LYEmptyView/LYEmptyViewHeader.h>

@implementation GLBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.child = (id<BaseVCManager>)self;
    
    [self initialzieBaseModel];
    [self initialzieEmptyView];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLViewModel *viewModel = [self.child valueForKeyPath: @"viewModel"];
    if([viewModel.isShowWirelessView boolValue] || [viewModel.isShowNodataView boolValue]) {
        return 0;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)initialzieEmptyView {
    if ([self.child respondsToSelector:@selector(autoShowEmptyView)]) {
        self.tableView.ly_emptyView.autoShowEmptyView = [self.child autoShowEmptyView];
    } else {
        self.tableView.ly_emptyView.autoShowEmptyView = NO;
    }
}

- (void)initialzieBaseModel {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (![self.child respondsToSelector:@selector(viewModel)]) {
        NSAssert(NO, @"子类必须要有viewModel");
    }
#pragma clang diagnostic pop
    
    if ([self.child valueForKeyPath: @"viewModel"] == nil) {
        NSAssert(NO, @"子类viewModel不能为nil");
    }
    
    if ([[self.child valueForKeyPath: @"viewModel"] superclass] != [GLViewModel class]) {
        NSAssert(NO, @"VC中的viewModel必须为GLViewModel的子类");
    }
    
    GLViewModel *viewModel = [self.child valueForKeyPath: @"viewModel"];
    if (viewModel == nil) {
        NSAssert(NO, @"子类必须要有viewModel");
    }
    
    [RACObserve(viewModel, isShowNodataView) subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]) {
            if ([self.child respondsToSelector:@selector(nodataView)]) {
                self.tableView.ly_emptyView = [LYEmptyView emptyViewWithCustomView:[self.child nodataView]];
                if (self.navigationController.navigationBar) {
                    self.tableView.ly_emptyView.contentViewY = self.view.frame.size.height / 2.0 - [self.child nodataView].frame.size.height / 2.0 - ([[UIApplication sharedApplication] statusBarFrame].size.height + 44);
                }
                [self.tableView reloadData];
                [self.tableView ly_showEmptyView];
            }
        }
    }];
    
    [RACObserve(viewModel, isShowWirelessView) subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]) {
            if ([self.child respondsToSelector:@selector(wirelessView)]) {
                self.tableView.ly_emptyView = [LYEmptyView emptyViewWithCustomView:[self.child wirelessView]];
                if (self.navigationController.navigationBar) {
                    self.tableView.ly_emptyView.contentViewY = self.view.frame.size.height / 2.0 - [self.child wirelessView].frame.size.height / 2.0 - ([[UIApplication sharedApplication] statusBarFrame].size.height + 44);
                }
                [self.tableView reloadData];
                [self.tableView ly_showEmptyView];
            }
        }
    }];
    
    [RACObserve(viewModel, isHiddenEmptyView) subscribeNext:^(id  _Nullable x) {
        [self.tableView reloadData];
        [self.tableView.ly_emptyView ly_hideEmptyView];
    }];
}

- (void)showTextHud:(NSString*)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
}

- (void)showActivityHudByText:(NSString*)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.label.text = text;
}

- (void)hideActivityHud {
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}

- (void)hideKeyBoard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

/**
 *  去掉多余的分割线
 *
 *  @param tableView 要去掉多余分割线的tableview
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
