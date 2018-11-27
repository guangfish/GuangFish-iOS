//
//  LoginChooseViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/11/14.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "LoginChooseViewController.h"
#import "HotSellHomeViewController.h"
#import <EAIntroView/EAIntroView.h>

@interface LoginChooseViewController ()<EAIntroDelegate>
@property (weak, nonatomic) IBOutlet UIButton *visitorButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneLoginButton;
@property (nonatomic, assign) BOOL isShowRegister;

@end

@implementation LoginChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isShowRegister = NO;
    
    [self initialzieView];
    [self initialzieModel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self showIntroPage];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.isShowRegister = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self appWillEnterForegroundNotification];
}

- (void)appWillEnterForegroundNotification {
    if (!self.isShowRegister) {
        if ([self.viewModel shouldShowRegisterViewController]) {
            self.isShowRegister = YES;
            [self performSegueWithIdentifier:@"ShowRegisterSegue" sender:nil];
        }
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

- (void)initialzieView {
    self.phoneLoginButton.layer.borderWidth = 1.0f;
    self.phoneLoginButton.layer.borderColor = [UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00].CGColor;
    self.phoneLoginButton.layer.cornerRadius = 18.0f;
    self.phoneLoginButton.layer.masksToBounds = YES;
}

- (void)initialzieModel {
    @weakify(self);
    self.visitorButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        UIStoryboard *hotSellStoryboard = [UIStoryboard storyboardWithName:@"HotSell" bundle:[NSBundle mainBundle]];
        HotSellHomeViewController *hotSellHomeViewController = [hotSellStoryboard instantiateViewControllerWithIdentifier:@"HotSellHomeViewController"];
        [self showViewController:hotSellHomeViewController sender:nil];
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
    intro.backgroundColor = [UIColor whiteColor];
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

- (LoginChooseVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [LoginChooseVM new];
    }
    return _viewModel;
}

@end
