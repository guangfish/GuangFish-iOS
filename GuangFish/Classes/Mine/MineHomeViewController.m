//
//  MineHomeViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/11/11.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "MineHomeViewController.h"

@interface MineHomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeCopyButton;
@property (weak, nonatomic) IBOutlet UIButton *codeCopyButton2;
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *paltformRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *drawButton;
@property (weak, nonatomic) IBOutlet UIButton *DrawRecordButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation MineHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialzieView];
    [self initialzieModel];
    [self.viewModel getUserData];
    [self.viewModel getBanner];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self setStatusBarBackgroundColor:[UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00]];
    
    [self.viewModel getDrawStats];
}

#pragma mark - UITableviewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 10) {
        [self.viewModel cleanMemory];
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

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)initialzieView {
    self.logoutButton.layer.borderWidth = 1.0f;
    self.logoutButton.layer.borderColor = [UIColor colorWithRed:0.94 green:0.57 blue:0.71 alpha:1.00].CGColor;
    self.logoutButton.layer.cornerRadius = 16.0f;
    self.logoutButton.layer.masksToBounds = YES;
}

- (void)initialzieModel {
    RAC(self.mobileLabel, text) = RACObserve(self.viewModel, mobile);
    RAC(self.totalMoneyLabel, text) = RACObserve(self.viewModel, totalMoney);
    RAC(self.orderMoneyLabel, text) = RACObserve(self.viewModel, orderMoney);
    RAC(self.paltformRewardLabel, text) = RACObserve(self.viewModel, paltformReward);
    RAC(self.versionLabel, text) = RACObserve(self.viewModel, version);
    
    @weakify(self);
    [self.viewModel.inviteCodeSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if (![x isKindOfClass:[NSError class]]) {
            [self showTextHud:x];
        }
    }];
    
    self.codeCopyButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self.viewModel inviteCodeCopy];
        return [RACSignal empty];
    }];
    
    self.codeCopyButton2.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self.viewModel inviteCodeCopy];
        return [RACSignal empty];
    }];
    
    [self.viewModel.requestGetBannerSignal subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
        if ([x isKindOfClass:[NSError class]]) {
            
        }
    }];
    
    [self.viewModel.cleanMemorySignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (![x isKindOfClass:[NSError class]]) {
            [self showTextHud:x];
        }
    }];
    
    self.drawButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if ([self.viewModel.hasBindAccount boolValue]) {
            if ([self.viewModel.drawBtnEnable boolValue]) {
                [self canDraw:YES withErrorMsg:nil];
            } else {
                [self canDraw:NO withErrorMsg:self.viewModel.reason];
            }
        } else {
            [self hasNotBindAccount];
        }
        return [RACSignal empty];
    }];
    
    self.DrawRecordButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self performSegueWithIdentifier:@"ShowDrawRecordSegue" sender:nil];
        return [RACSignal empty];
    }];
    
    self.logoutButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self.viewModel logout];
        
        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UINavigationController *loginNavigationController = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        [UIApplication sharedApplication].keyWindow.rootViewController = loginNavigationController;
        
        return [RACSignal empty];
    }];
}

- (void)canDraw:(BOOL)canDraw withErrorMsg:(NSString *)errorMsg {
    if (canDraw) {
        [self performSegueWithIdentifier:@"ShowDrawSegue" sender:nil];
    } else {
        [self showTextHud:errorMsg];
    }
}

- (void)hasNotBindAccount {
    [self performSegueWithIdentifier:@"ShowBindAccountSegue" sender:nil];
}

#pragma mark - getters and setters

- (MineHomeVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [MineHomeVM new];
    }
    return _viewModel;
}

@end
