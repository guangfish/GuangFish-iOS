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
#import "MenuButton.h"
#import "JCAlertController.h"
#import "MBProgressHUD.h"
#import "OrderRewardViewController.h"

@interface FriendsHomeViewController ()<QCSlideSwitchViewDelegate, MenuButtonDelegate>

@property (nonatomic, strong) MenuButton *menuButton;
@property (nonatomic, strong) NSMutableArray *controllersArray;
@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;
@property (weak, nonatomic) IBOutlet UIButton *wjhButton;
@property (weak, nonatomic) IBOutlet UIButton *yqjlButton;
@property (weak, nonatomic) IBOutlet UIButton *ddjlButton;
@property (weak, nonatomic) IBOutlet UIView *wjhSelectedView;
@property (weak, nonatomic) IBOutlet UIView *wlqSelectedView;
@property (weak, nonatomic) IBOutlet UIView *ylqSelectedView;
@property (nonatomic, strong) JCAlertController *alertController;

@end

@implementation FriendsHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slideSwitchView.isTopHide = YES;
    self.slideSwitchView.slideSwitchViewDelegate = self;
    [self.slideSwitchView buildUI];
    [self.view addSubview:self.menuButton];
    
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

#pragma mark - MenuButtonDelegate

- (void)menuButtonTouch:(NSInteger)indexPath {
    switch (indexPath) {
        case 1:
            [self performSegueWithIdentifier:@"ShowBdyqmSegue" sender:nil];
            break;
            
        case 2:
            [JCPresentController presentViewControllerLIFO:self.alertController presentCompletion:nil dismissCompletion:nil];
            break;
            
        case 3:
            [self performSegueWithIdentifier:@"ShowYqgzSegue" sender:nil];
            break;
            
        default:
            break;
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

#pragma mark - actions

- (void)alertDoneBtnAction:(id)sender {
    [self.alertController dismissViewControllerAnimated:YES completion:nil];
    [self.viewModel copyInviteCode];
}

- (void)alertCancelBtnAction:(id)sender {
    [self.alertController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private methods

- (void)initialzieModel {
    @weakify(self)
    [self.viewModel.inviteCodeSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if (![x isKindOfClass:[NSError class]]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = x;
            hud.margin = 10.0f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:6];
        }
    }];
    
    self.wjhButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        [self chooseWJH];
        return [RACSignal empty];
    }];
    
    self.yqjlButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        [self chooseWLQ];
        return [RACSignal empty];
    }];
    
    self.ddjlButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        [self chooseYLQ];
        return [RACSignal empty];
    }];
}

- (void)chooseWJH {
    [self.wjhButton setTitleColor:[UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00] forState:(UIControlStateNormal)];
    [self.yqjlButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.ddjlButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    self.wjhSelectedView.hidden = NO;
    self.wlqSelectedView.hidden = YES;
    self.ylqSelectedView.hidden = YES;
    [self.slideSwitchView switchByTag:0];
}

- (void)chooseWLQ {
    [self.wjhButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.yqjlButton setTitleColor:[UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00] forState:(UIControlStateNormal)];
    [self.ddjlButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    self.wjhSelectedView.hidden = YES;
    self.wlqSelectedView.hidden = NO;
    self.ylqSelectedView.hidden = YES;
    [self.slideSwitchView switchByTag:1];
}

- (void)chooseYLQ {
    [self.wjhButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.yqjlButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.ddjlButton setTitleColor:[UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00] forState:(UIControlStateNormal)];
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
        
        UIStoryboard *friendsStoryboard = [UIStoryboard storyboardWithName:@"Friends" bundle:[NSBundle mainBundle]];
        FriendsListViewController *wjhFriendsListViewController = [friendsStoryboard instantiateViewControllerWithIdentifier:@"FriendsListViewController"];
        wjhFriendsListViewController.viewModel = [self.viewModel getWJHFriendListVM];
        wjhFriendsListViewController.title = @"未激活";
        
        FriendsListViewController *yqjlFriendsListViewController = [friendsStoryboard instantiateViewControllerWithIdentifier:@"FriendsListViewController"];
        yqjlFriendsListViewController.viewModel = [self.viewModel getYQJLFriendListVM];
        yqjlFriendsListViewController.title = @"邀请奖励";
        
        OrderRewardViewController *orderRewardViewController = [friendsStoryboard instantiateViewControllerWithIdentifier:@"OrderRewardViewController"];
        orderRewardViewController.title = @"订单奖励";
        
        [self.controllersArray addObjectsFromArray:@[wjhFriendsListViewController, yqjlFriendsListViewController, orderRewardViewController]];
    }
    return _controllersArray;
}

- (MenuButton*)menuButton {
    if (_menuButton == nil) {
        CGFloat tabbarH = ((([[UIApplication sharedApplication] statusBarFrame].size.height)>20)?83:49);
        self.menuButton = [[MenuButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 48 - 55 - tabbarH, 55, 55)];
        self.menuButton.buttonImageArray = @[[UIImage imageNamed:@"img_bdyqm"], [UIImage imageNamed:@"img_yqhy"], [UIImage imageNamed:@"img_yqgz"]];
        self.menuButton.delegate = self;
    }
    return _menuButton;
}

- (JCAlertController*)alertController {
    if (_alertController == nil) {
        CGFloat width = self.view.frame.size.width - 88;
        [JCAlertStyle shareStyle].alertView.width = width;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 400)];
        contentView.layer.cornerRadius = 10.0f;
        contentView.backgroundColor = [UIColor whiteColor];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(width - 15 - 19, 15, 19, 19)];
        [cancelButton setImage:[UIImage imageNamed:@"img_alert_cancel"] forState:(UIControlStateNormal)];
        [cancelButton addTarget:self action:@selector(alertCancelBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [contentView addSubview:cancelButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 52, width - 40, 400 - 52 - 90)];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.numberOfLines = 0;
        label.textColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.00];
        label.text = self.viewModel.inviteCode;
        [contentView addSubview:label];
        
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(42, 335, width - 84, 35)];
        doneButton.backgroundColor = [UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00];
        [doneButton setTitle:@"邀请好友" forState:(UIControlStateNormal)];
        doneButton.layer.cornerRadius = 5.0f;
        [doneButton addTarget:self action:@selector(alertDoneBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [contentView addSubview:doneButton];
        
        self.alertController = [JCAlertController alertWithTitle:nil contentView:contentView];
    }
    return _alertController;
}

@end
