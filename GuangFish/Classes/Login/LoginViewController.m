//
//  LoginViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialzieModel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if ([self.viewModel shouldShowRegisterViewController]) {
        [self performSegueWithIdentifier:@"ShowRegisterSegue" sender:nil];
    }
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
    
    @weakify(self);
    
    [RACObserve(self.viewModel, version) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.versionLabel.text = [NSString stringWithFormat:@"逛鱼:%@", x];
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
    
    [self.viewModel.requestLoginSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *homeNavigationController = [homeStoryboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
            [UIApplication sharedApplication].keyWindow.rootViewController = homeNavigationController;
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
    
    self.loginButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if ([self.viewModel isValidInput]) {
            [self showActivityHudByText:@""];
            [self.viewModel doLogin];
        }
        return [RACSignal empty];
    }];
}

#pragma mark - getters and setters

- (LoginVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [LoginVM new];
    }
    return _viewModel;
}

@end
