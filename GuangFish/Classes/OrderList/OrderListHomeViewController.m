//
//  OrderListHomeViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/30.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "OrderListHomeViewController.h"
#import "QCSlideSwitchView.h"
#import "OrderListViewController.h"

@interface OrderListHomeViewController ()<QCSlideSwitchViewDelegate>

@property (nonatomic, strong) NSMutableArray *controllersArray;
@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;
@property (weak, nonatomic) IBOutlet UIButton *jsButton;
@property (weak, nonatomic) IBOutlet UIButton *fkButton;
@property (weak, nonatomic) IBOutlet UIButton *sxButton;
@property (weak, nonatomic) IBOutlet UIView *jsSelectedView;
@property (weak, nonatomic) IBOutlet UIView *fkSelectedView;
@property (weak, nonatomic) IBOutlet UIView *sxSelectedView;

@end

@implementation OrderListHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.slideSwitchView.isTopHide = YES;
    self.slideSwitchView.slideSwitchViewDelegate = self;
    [self.slideSwitchView buildUI];
    
    [self initialzieModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - QCSlideSwitchViewDelegate

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view {
    return self.controllersArray.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number {
    return [self.controllersArray objectAtIndex:number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number {
    if (number == 0) {
        [self chooseJS];
    } else if (number == 1) {
        [self chooseFK];
    } else if (number == 2) {
        [self chooseSX];
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

#pragma mark - private methods

- (void)initialzieModel {
    @weakify(self)
    self.jsButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        [self chooseJS];
        return [RACSignal empty];
    }];
    
    self.fkButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        [self chooseFK];
        return [RACSignal empty];
    }];
    
    self.sxButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        [self chooseSX];
        return [RACSignal empty];
    }];
}

- (void)chooseJS {
    [self.jsButton setTitleColor:[UIColor colorWithRed:0.90 green:0.31 blue:0.33 alpha:1.00] forState:(UIControlStateNormal)];
    [self.fkButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.sxButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    self.jsSelectedView.hidden = NO;
    self.fkSelectedView.hidden = YES;
    self.sxSelectedView.hidden = YES;
    [self.slideSwitchView switchByTag:0];
}

- (void)chooseFK {
    [self.jsButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.fkButton setTitleColor:[UIColor colorWithRed:0.90 green:0.31 blue:0.33 alpha:1.00] forState:(UIControlStateNormal)];
    [self.sxButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    self.jsSelectedView.hidden = YES;
    self.fkSelectedView.hidden = NO;
    self.sxSelectedView.hidden = YES;
    [self.slideSwitchView switchByTag:1];
}

- (void)chooseSX {
    [self.jsButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.fkButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.sxButton setTitleColor:[UIColor colorWithRed:0.90 green:0.31 blue:0.33 alpha:1.00] forState:(UIControlStateNormal)];
    self.jsSelectedView.hidden = YES;
    self.fkSelectedView.hidden = YES;
    self.sxSelectedView.hidden = NO;
    [self.slideSwitchView switchByTag:2];
}

#pragma mark - getters and setters

- (OrderListHomeVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [OrderListHomeVM new];
    }
    return _viewModel;
}

- (NSMutableArray*)controllersArray {
    if (_controllersArray == nil) {
        self.controllersArray = [[NSMutableArray alloc] initWithCapacity:2];
        
        UIStoryboard *mineStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        OrderListViewController *jsFriendsListViewController = [mineStoryboard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
        jsFriendsListViewController.viewModel = [self.viewModel getJSOrderListVM];
        jsFriendsListViewController.title = @"订单结算";
        
        OrderListViewController *fkFriendsListViewController = [mineStoryboard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
        fkFriendsListViewController.viewModel = [self.viewModel getFKOrderListVM];
        fkFriendsListViewController.title = @"订单付款";
        
        OrderListViewController *sxFriendsListViewController = [mineStoryboard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
        sxFriendsListViewController.viewModel = [self.viewModel getSXOrderListVM];
        sxFriendsListViewController.title = @"订单失效";
        
        [self.controllersArray addObjectsFromArray:@[jsFriendsListViewController, fkFriendsListViewController, sxFriendsListViewController]];
    }
    return _controllersArray;
}

@end
