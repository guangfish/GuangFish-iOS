//
//  SmartSearchManager.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/30.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "SmartSearchManager.h"
#import <UIKit/UIKit.h>
#import "GoodsListViewController.h"

@interface SmartSearchManager()

@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) NSString *searchStr;
@property (nonatomic, strong) GoodsListVM *goodsListVM;
@property (nonatomic, strong) GoodsListViewController *goodsListViewController;

@end

@implementation SmartSearchManager

static SmartSearchManager *sharedManager = nil;

+ (SmartSearchManager*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - public methods

- (void)beginSearch {
    self.searchStr = [UIPasteboard generalPasteboard].string;
    if (self.searchStr.length > 0) {
        [[self getCurrentVC] presentViewController:self.alertController animated:YES completion:nil];
        self.alertController.message = self.searchStr;
        self.goodsListVM.searchStr = self.searchStr;
        [self.goodsListVM loadNextPageGoodsList];
    }
}

#pragma mark - private methods

- (void)showGoodsListViewController {
//    [[self getCurrentVC] presentViewController:self.goodsListViewController animated:YES completion:nil];
    [[self getCurrentVC] showViewController:self.goodsListViewController sender:nil];
}

- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

#pragma mark - getters and setters

- (UIAlertController*)alertController {
    if (_alertController == nil) {
        self.alertController = [UIAlertController alertControllerWithTitle:@"智能搜索" message:self.searchStr preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [self.alertController addAction:cancelAction];
        @weakify(self)
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self showGoodsListViewController];
        }];
        [self.alertController addAction:doneAction];
    }
    return _alertController;
}

- (GoodsListVM*)goodsListVM {
    if (_goodsListVM == nil) {
        self.goodsListVM = [[GoodsListVM alloc] init];
    }
    return _goodsListVM;
}

- (GoodsListViewController*)goodsListViewController {
    if (_goodsListViewController == nil) {
        UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.goodsListViewController = [homeStoryboard instantiateViewControllerWithIdentifier:@"GoodsListViewController"];
        self.goodsListViewController.viewModel = self.goodsListVM;
    }
    return _goodsListViewController;
}

@end
