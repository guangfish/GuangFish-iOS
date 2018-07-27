//
//  FriendsHomeViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/26.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "FriendsHomeViewController.h"
#import "QCSlideSwitchView.h"
#import "FriendsListViewController.h"

@interface FriendsHomeViewController ()<QCSlideSwitchViewDelegate>

@property (nonatomic, strong) NSMutableArray *controllersArray;
@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;
@property (weak, nonatomic) IBOutlet UIButton *wjhButton;
@property (weak, nonatomic) IBOutlet UIButton *wlqButton;
@property (weak, nonatomic) IBOutlet UIButton *ylqButton;
@property (weak, nonatomic) IBOutlet UIView *wjhSelectedView;
@property (weak, nonatomic) IBOutlet UIView *wlqSelectedView;
@property (weak, nonatomic) IBOutlet UIView *ylqSelectedView;

@end

@implementation FriendsHomeViewController

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
        [self chooseWJH];
    } else if (number == 1) {
        [self chooseWLQ];
    } else if (number == 2) {
        [self chooseYLQ];
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
    self.wjhButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        [self chooseWJH];
        return [RACSignal empty];
    }];
    
    self.wlqButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        [self chooseWLQ];
        return [RACSignal empty];
    }];
    
    self.ylqButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        [self chooseYLQ];
        return [RACSignal empty];
    }];
}

- (void)chooseWJH {
    [self.wjhButton setTitleColor:[UIColor colorWithRed:0.90 green:0.31 blue:0.33 alpha:1.00] forState:(UIControlStateNormal)];
    [self.wlqButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.ylqButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    self.wjhSelectedView.hidden = NO;
    self.wlqSelectedView.hidden = YES;
    self.ylqSelectedView.hidden = YES;
    [self.slideSwitchView switchByTag:0];
}

- (void)chooseWLQ {
    [self.wjhButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.wlqButton setTitleColor:[UIColor colorWithRed:0.90 green:0.31 blue:0.33 alpha:1.00] forState:(UIControlStateNormal)];
    [self.ylqButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    self.wjhSelectedView.hidden = YES;
    self.wlqSelectedView.hidden = NO;
    self.ylqSelectedView.hidden = YES;
    [self.slideSwitchView switchByTag:1];
}

- (void)chooseYLQ {
    [self.wjhButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.wlqButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.ylqButton setTitleColor:[UIColor colorWithRed:0.90 green:0.31 blue:0.33 alpha:1.00] forState:(UIControlStateNormal)];
    self.wjhSelectedView.hidden = YES;
    self.wlqSelectedView.hidden = YES;
    self.ylqSelectedView.hidden = NO;
    [self.slideSwitchView switchByTag:2];
}

#pragma mark - getters and setters

- (FriendsHomeVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [FriendsHomeVM new];
    }
    return _viewModel;
}

- (NSMutableArray*)controllersArray {
    if (_controllersArray == nil) {
        self.controllersArray = [[NSMutableArray alloc] initWithCapacity:2];
        
        UIStoryboard *mineStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        FriendsListViewController *wjhFriendsListViewController = [mineStoryboard instantiateViewControllerWithIdentifier:@"FriendsListViewController"];
        wjhFriendsListViewController.viewModel = [self.viewModel getWJHFriendListVM];
        wjhFriendsListViewController.title = @"未激活";
        
        FriendsListViewController *wlqFriendsListViewController = [mineStoryboard instantiateViewControllerWithIdentifier:@"FriendsListViewController"];
        wlqFriendsListViewController.viewModel = [self.viewModel getWLQFriendListVM];
        wlqFriendsListViewController.title = @"未领取";
        
        FriendsListViewController *ylqFriendsListViewController = [mineStoryboard instantiateViewControllerWithIdentifier:@"FriendsListViewController"];
        ylqFriendsListViewController.viewModel = [self.viewModel getYLQFriendListVM];
        ylqFriendsListViewController.title = @"已领取";
        
        [self.controllersArray addObjectsFromArray:@[wjhFriendsListViewController, wlqFriendsListViewController, ylqFriendsListViewController]];
    }
    return _controllersArray;
}

@end
