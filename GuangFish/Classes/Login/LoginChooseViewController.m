//
//  LoginChooseViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/11/14.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "LoginChooseViewController.h"
#import "HotSellHomeViewController.h"

@interface LoginChooseViewController ()
@property (weak, nonatomic) IBOutlet UIButton *visitorButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneLoginButton;

@end

@implementation LoginChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

#pragma mark - getters and setters

- (LoginChooseVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [LoginChooseVM new];
    }
    return _viewModel;
}

@end
