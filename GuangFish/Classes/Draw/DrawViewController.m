//
//  DrawViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/26.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "DrawViewController.h"

@interface DrawViewController ()

@property (weak, nonatomic) IBOutlet UIView *inputBgView;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *drawBtn;
@property (nonatomic, strong) UIAlertController *drawSuccessAlertController;

@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialzieView];
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
    [RACObserve(self.viewModel, doneBtnEnable) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        BOOL enable = [x boolValue];
        self.drawBtn.enabled = enable;
        if (enable) {
            self.drawBtn.backgroundColor = [UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00];
        } else {
            self.drawBtn.backgroundColor = [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.00];
        }
    }];
    
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

- (void)initialzieView {
    self.inputBgView.layer.cornerRadius = 5.0f;
    self.inputBgView.layer.borderWidth = 1.0f;
    self.inputBgView.layer.borderColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.00].CGColor;
    
    self.drawBtn.layer.cornerRadius = 5.0f;
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
