//
//  DrawViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/26.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "DrawViewController.h"

@interface DrawViewController ()

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *drawBtn;
@property (nonatomic, strong) UIAlertController *drawSuccessAlertController;

@end

@implementation DrawViewController

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
    RAC(self.viewModel, code) = self.codeTextField.rac_textSignal;
    
    @weakify(self);
    [RACObserve(self.viewModel, sendCodeButtonTitleStr) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.getCodeBtn.titleLabel.text = x;
        [self.getCodeBtn setTitle:x forState:(UIControlStateNormal)];
    }];
    
    [RACObserve(self.viewModel, sendCodeButtonEnable) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        BOOL enable = [x boolValue];
        self.getCodeBtn.userInteractionEnabled = enable;
    }];
    
    [self.viewModel.requestSendCodeSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        }
    }];
    
    [self.viewModel.requestDrawSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            [self presentViewController:self.drawSuccessAlertController animated:YES completion:nil];
        }
    }];
    
    self.getCodeBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self showActivityHudByText:@""];
        [self.viewModel doSendCode];
        return [RACSignal empty];
    }];
    
    self.drawBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if ([self.viewModel isValidInput]) {
            [self showActivityHudByText:@""];
            [self.viewModel doDraw];
        }
        return [RACSignal empty];
    }];
}

#pragma mark - getters and setters

- (DrawVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [DrawVM new];
    }
    return _viewModel;
}

- (UIAlertController*)drawSuccessAlertController {
    if (_drawSuccessAlertController == nil) {
        self.drawSuccessAlertController = [UIAlertController alertControllerWithTitle:@"提现申请成功" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        @weakify(self);
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.drawSuccessAlertController addAction:doneAction];
    }
    return _drawSuccessAlertController;
}

@end
