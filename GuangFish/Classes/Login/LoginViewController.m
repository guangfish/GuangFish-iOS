//
//  LoginViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "LoginViewController.h"
#import <EAIntroView/EAIntroView.h>

@interface LoginViewController ()<EAIntroDelegate>

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self showIntroPage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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

- (void)appWillEnterForegroundNotification {
    if ([self.viewModel shouldShowRegisterViewController]) {
        [self performSegueWithIdentifier:@"ShowRegisterSegue" sender:nil];
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
    RAC(self.viewModel, mobile) = self.mobileTextField.rac_textSignal;
    RAC(self.viewModel, code) = self.codeTextField.rac_textSignal;
    
    @weakify(self);
    
    [self.mobileTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSString *toBeString = x;
        if (toBeString.length > 11) {
            self.mobileTextField.text = [toBeString substringToIndex:11];
        }
    }];
    
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

- (void)showIntroPage {
    BOOL introPageIsShow = [[NSUserDefaults standardUserDefaults] boolForKey:@"IntroPageIsShow"];
    if (introPageIsShow == YES) {
        return;
    }
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"img_ydy1"];
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"img_ydy2"];
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"img_ydy3"];
    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"img_ydy4"];
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    [intro.skipButton setTitle:@"跳过" forState:(UIControlStateNormal)];
    [intro.skipButton setTitleColor:[UIColor colorWithRed:0.93 green:0.18 blue:0.42 alpha:1.00] forState:(UIControlStateNormal)];
    intro.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.93 green:0.18 blue:0.42 alpha:1.00];
    intro.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.98 green:0.73 blue:0.81 alpha:1.00];
    [intro showInView:self.view animateDuration:0.0];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setBool:YES forKey:@"IntroPageIsShow"];
    [userDef synchronize];
}

#pragma mark - getters and setters

- (LoginVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [LoginVM new];
    }
    return _viewModel;
}

@end
