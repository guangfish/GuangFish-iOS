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
@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation OrderSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [self.viewModel.saveOrderSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
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

#pragma mark - getters and setters

- (OrderSaveVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [OrderSaveVM new];
    }
    return _viewModel;
}

- (UIAlertController*)alertController {
    if (_alertController == nil) {
        self.alertController = [UIAlertController alertControllerWithTitle:nil message:@"订单保存成功" preferredStyle:(UIAlertControllerStyleAlert)];
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
