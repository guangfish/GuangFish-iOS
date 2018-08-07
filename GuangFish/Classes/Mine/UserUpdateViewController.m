//
//  UserUpdateViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/8/7.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "UserUpdateViewController.h"

@interface UserUpdateViewController ()

@property (weak, nonatomic) IBOutlet UITextField *alipayTextField;
@property (weak, nonatomic) IBOutlet UITextField *weixinTextField;
@property (weak, nonatomic) IBOutlet UIButton *alipayCopyButton;
@property (weak, nonatomic) IBOutlet UIButton *bindButton;
@property (nonatomic, strong) UIAlertController *successedAlertController;

@end

@implementation UserUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialzieModel];
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
    RAC(self.viewModel, alipay) = self.alipayTextField.rac_textSignal;
    RAC(self.viewModel, weixin) = self.weixinTextField.rac_textSignal;
    
    @weakify(self);
    [self.viewModel.requestUserUpdateSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            [self presentViewController:self.successedAlertController animated:YES completion:nil];
        }
    }];
    
    self.alipayCopyButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        self.weixinTextField.text = self.alipayTextField.text;
        self.viewModel.weixin = self.weixinTextField.text;
        return [RACSignal empty];
    }];
    
    self.bindButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if ([self.viewModel isValidInput]) {
            [self showActivityHudByText:@""];
            [self.viewModel doUserUpdate];
        }
        return [RACSignal empty];
    }];
}

#pragma mark - getters and setters

- (UserUpdateVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [UserUpdateVM new];
    }
    return _viewModel;
}

- (UIAlertController*)successedAlertController {
    if (_successedAlertController == nil) {
        self.successedAlertController = [UIAlertController alertControllerWithTitle:@"绑定成功" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        @weakify(self);
        UIAlertAction *doneAlertAction = [UIAlertAction actionWithTitle:@"好的" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.successedAlertController addAction:doneAlertAction];
    }
    return _successedAlertController;
}

@end
