//
//  OrderSaveViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/23.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "OrderSaveViewController.h"

@interface OrderSaveViewController ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIView *inputBgView;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) NSString *alertMsg;

@end

@implementation OrderSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialzieView];
    [self initialzieModel];
    
    self.orderIdTextField.text = [self.viewModel getOrderIdFromPasteboard];
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
    RAC(self.viewModel, orderId) = self.orderIdTextField.rac_textSignal;
    
    @weakify(self);
    
    [RACObserve(self.viewModel, doneBtnEnable) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        BOOL enable = [x boolValue];
        self.saveButton.enabled = enable;
        if (enable) {
            self.saveButton.backgroundColor = [UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00];
        } else {
            self.saveButton.backgroundColor = [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.00];
        }
    }];
    
    [self.viewModel.saveOrderSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            self.alertMsg = x;
            [self presentViewController:self.alertController animated:YES completion:nil];
        }
    }];
    
    self.saveButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if ([self.viewModel isValidInput]) {
            [self showActivityHudByText:@""];
            [self.viewModel saveOrderID];
        }
        return [RACSignal empty];
    }];
}

- (void)initialzieView {
    self.inputBgView.layer.cornerRadius = 5.0f;
    self.inputBgView.layer.borderWidth = 1.0f;
    self.inputBgView.layer.borderColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.00].CGColor;
    
    self.saveButton.layer.cornerRadius = 5.0f;
}

#pragma mark - getters and setters

- (OrderSaveVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [OrderSaveVM new];
    }
    return _viewModel;
}

- (UIAlertController*)alertController {
    if (_alertController == nil) {
        self.alertController = [UIAlertController alertControllerWithTitle:nil message:self.alertMsg preferredStyle:(UIAlertControllerStyleAlert)];
        @weakify(self);
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.alertController addAction:alertAction];
    }
    return _alertController;
}

@end
