//
//  RegisterViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/17.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inviteCodeTextField.text = [self.viewModel getInviteCode];
    
    [self initialzieModel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    RAC(self.viewModel, mobile) = self.mobileTextField.rac_textSignal;
    RAC(self.viewModel, code) = self.codeTextField.rac_textSignal;
    RAC(self.viewModel, inviteCode) = self.inviteCodeTextField.rac_textSignal;
    
    @weakify(self);
    
    [self.mobileTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSString *toBeString = x;
        if (toBeString.length > 11) {
            self.mobileTextField.text = [toBeString substringToIndex:11];
        }
    }];
    
    [RACObserve(self.viewModel, sendCodeButtonTitleStr) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.codeButton.titleLabel.text = x;
        [self.codeButton setTitle:x forState:(UIControlStateNormal)];
    }];
    
    [RACObserve(self.viewModel, sendCodeButtonEnable) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        BOOL enable = [x boolValue];
        self.codeButton.userInteractionEnabled = enable;
    }];
    
    [self.viewModel.requestSendCodeSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        }
    }];
    
    [self.viewModel.requestRegisterSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    self.codeButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if ([self.viewModel isValidSendCodeInput]) {
            [self showActivityHudByText:@""];
            [self.viewModel doSendCode];
        }
        return [RACSignal empty];
    }];
    
    self.registerButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if ([self.viewModel isValidInput]) {
            [self showActivityHudByText:@""];
            [self.viewModel doRegister];
        }
        return [RACSignal empty];
    }];
}

- (void)appWillEnterForegroundNotification {
    self.inviteCodeTextField.text = [self.viewModel getInviteCode];
}

#pragma mark - getters and setters

- (RegisterVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [RegisterVM new];
    }
    return _viewModel;
}

@end
