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
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "OrderSaveViewController.h"

@interface SmartSearchManager()

@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) NSString *searchStr;

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
    if ([[self getCurrentVC] isKindOfClass:LoginViewController.class] || [[self getCurrentVC] isKindOfClass:RegisterViewController.class]) {
        return;
    }
    
    self.searchStr = [UIPasteboard generalPasteboard].string;
    if (self.searchStr.length > 0) {
        if ([self isOrderNum:self.searchStr]) {
            [self showOrderSaveViewController];
        } else if ([self isInviteCode:self.searchStr]) {
            
        } else {
            [[self getCurrentVC] presentViewController:self.alertController animated:YES completion:nil];
            self.alertController.message = self.searchStr;
            [UIPasteboard generalPasteboard].string = @"";
        }
    }
}

#pragma mark - private methods

- (void)showGoodsListViewController {
    if ([[self getCurrentVC] isKindOfClass:GoodsListViewController.class]) {
        GoodsListViewController *goodsListViewController = (GoodsListViewController*)[self getCurrentVC];
        goodsListViewController.viewModel.searchStr = self.searchStr;
        [goodsListViewController reloadData];
    } else {
        UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
        GoodsListViewController *goodsListViewController = [homeStoryboard instantiateViewControllerWithIdentifier:@"GoodsListViewController"];
        GoodsListVM *goodsListVM = [[GoodsListVM alloc] init];
        goodsListVM.searchStr = self.searchStr;
        goodsListViewController.viewModel = goodsListVM;
        [[self getCurrentVC] showViewController:goodsListViewController sender:nil];
    }
}

- (void)showOrderSaveViewController {
    if ([[self getCurrentVC] isKindOfClass:OrderSaveViewController.class]) {
        return;
    } else {
        UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
        OrderSaveViewController *orderSaveViewController = [homeStoryboard instantiateViewControllerWithIdentifier:@"OrderSaveViewController"];
        [[self getCurrentVC] showViewController:orderSaveViewController sender:nil];
    }
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

- (BOOL)isOrderNum:(NSString*)str {
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str] && (str.length == 11 || str.length == 18)) {
        return YES;
    }
    return NO;
}

- (BOOL)isInviteCode:(NSString*)str {
    NSString *resultStr = [self subStringComponentsSeparatedByStrContent:str strPoint:@"Ʊ" firstFlag:1 secondFlag:2];
    if (resultStr.length > 0) {
        return YES;
    }
    return NO;
}

- (NSString *)subStringComponentsSeparatedByStrContent:(NSString *)strContent strPoint:(NSString *)strPoint firstFlag:(int)firstFlag secondFlag:(int)secondFlag {
    NSInteger scount = [[strContent mutableCopy] replaceOccurrencesOfString:@"Ʊ" // 要查询的字符串中的某个字符
                                                                 withString:@"Ʊ"
                                                                    options:NSLiteralSearch
                                                                      range:NSMakeRange(0, [strContent length])];
    
    if (scount != 2) {
        return @"";
    }
    
    // 初始化一个起始位置和结束位置
    NSRange startRange = NSMakeRange(0, 1);
    NSRange endRange = NSMakeRange(0, 1);
    
    // 获取传入的字符串的长度
    NSInteger strLength = [strContent length];
    // 初始化一个临时字符串变量
    NSString *temp = nil;
    // 标记一下找到的同一个字符的次数
    int count = 0;
    // 开始循环遍历传入的字符串，找寻和传入的 strPoint 一样的字符
    for(int i = 0; i < strLength; i++)
    {
        // 截取字符串中的每一个字符,赋值给临时变量字符串
        temp = [strContent substringWithRange:NSMakeRange(i, 1)];
        // 判断临时字符串和传入的参数字符串是否一样
        if ([temp isEqualToString:strPoint]) {
            // 遍历到的相同字符引用计数+1
            count++;
            if (firstFlag == count)
            {
                // 遍历字符串，第一次遍历到和传入的字符一样的字符
                NSLog(@"第%d个字是:%@", i, temp);
                // 将第一次遍历到的相同字符的位置，赋值给起始截取的位置
                startRange = NSMakeRange(i, 1);
            }
            else if (secondFlag == count)
            {
                // 遍历字符串，第二次遍历到和传入的字符一样的字符
                NSLog(@"第%d个字是:%@", i, temp);
                // 将第二次遍历到的相同字符的位置，赋值给结束截取的位置
                endRange = NSMakeRange(i, i);
            }
        }
    }
    // 根据起始位置和结束位置，截取相同字符之间的字符串的范围
    NSRange rangeMessage = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    // 根据得到的截取范围，截取想要的字符串，赋值给结果字符串
    NSString *result = [strContent substringWithRange:rangeMessage];
    // 打印一下截取到的字符串，看看是否是想要的结果
    NSLog(@"截取到的 strResult = %@", result);
    // 最后将结果返回出去
    return result;
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

@end
