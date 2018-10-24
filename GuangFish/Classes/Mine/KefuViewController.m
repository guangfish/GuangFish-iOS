//
//  KefuViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/24.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "KefuViewController.h"

@interface KefuViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ewmImageView;
@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation KefuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialzieModel];
    
    [self.ewmImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEwmImageView:)]];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPassAction:)];
    [self.ewmImageView addGestureRecognizer:longPress];
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
    @weakify(self)
    [self.viewModel.wxNameCopySignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if (![x isKindOfClass:[NSError class]]) {
            [self showTextHud:x];
        }
    }];
}

- (void)clickEwmImageView:(id)sender {
    [self.viewModel copyWxName];
}

- (void)longPassAction:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self presentViewController:self.alertController animated:YES completion:nil];
    }
}

- (void)image:(UIImage *)image didFinshSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *mes = nil;
    if (error != nil) {
        [self showTextHud:@"保存图片失败"];
    } else {
        [self showTextHud:@"保存图片成功"];
    }
}

#pragma mark - setters and getters

- (KefuVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[KefuVM alloc] init];
    }
    return _viewModel;
}

- (UIAlertController*)alertController {
    if (_alertController == nil) {
        self.alertController = [UIAlertController alertControllerWithTitle:@"保存二维码" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [self.alertController addAction:cancelAction];
        @weakify(self);
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存到系统相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            UIImageWriteToSavedPhotosAlbum(self.ewmImageView.image, self, @selector(image:didFinshSavingWithError:contextInfo:), nil);
        }];
        [self.alertController addAction:saveAction];
    }
    return _alertController;
}

@end
