//
//  BindCodeViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/9.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "BindCodeViewController.h"

@interface BindCodeViewController ()
@property (weak, nonatomic) IBOutlet UIView *textFieldBgView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation BindCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialzieModel];
    [self initialzieView];
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
        self.doneButton.enabled = enable;
        if (enable) {
            self.doneButton.backgroundColor = [UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00];
        } else {
            self.doneButton.backgroundColor = [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.00];
        }
    }];
}

- (void)initialzieView {
    self.textFieldBgView.layer.cornerRadius = 5.0f;
    self.textFieldBgView.layer.borderWidth = 1.0f;
    self.textFieldBgView.layer.borderColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.00].CGColor;
    
    self.doneButton.layer.cornerRadius = 5.0f;
}

#pragma mark - setters and getters

- (BindCodeVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[BindCodeVM alloc] init];
    }
    return _viewModel;
}

@end
