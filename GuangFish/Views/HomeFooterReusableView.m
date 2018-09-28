//
//  HomeFooterReusableView.m
//  GuangFish
//
//  Created by 顾越超 on 2018/9/28.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HomeFooterReusableView.h"
#import "HomeFooterReusableVM.h"

@interface HomeFooterReusableView()

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation HomeFooterReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialzieView];
    [self initialzieModel];
}

#pragma mark - private methods

- (void)initialzieView {
    self.logoutButton.layer.borderWidth = 1.0f;
    self.logoutButton.layer.borderColor = [UIColor colorWithRed:0.94 green:0.57 blue:0.71 alpha:1.00].CGColor;
    self.logoutButton.layer.cornerRadius = 16.0f;
    self.logoutButton.layer.masksToBounds = YES;
}

- (void)initialzieModel {
    @weakify(self);
    self.logoutButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self.viewModel logout];
        
        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UINavigationController *loginNavigationController = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        [UIApplication sharedApplication].keyWindow.rootViewController = loginNavigationController;
        
        return [RACSignal empty];
    }];
}

#pragma mark - getters and setters

- (HomeFooterReusableVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[HomeFooterReusableVM alloc] init];
    }
    return _viewModel;
}

@end
