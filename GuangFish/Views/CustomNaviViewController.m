//
//  CustomNaviViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/12/18.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "CustomNaviViewController.h"

@interface CustomNaviViewController ()<UINavigationControllerDelegate>

@property (nonatomic, getter=isPushing) BOOL pushing;

@end

@implementation CustomNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.pushing == YES) {
        NSLog(@"被拦截");
        return;
    } else {
        NSLog(@"push");
        self.pushing = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}


#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.pushing = NO;
}

@end
