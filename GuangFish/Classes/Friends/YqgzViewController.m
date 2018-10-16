//
//  YqgzViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/15.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "YqgzViewController.h"

@interface YqgzViewController ()

@end

@implementation YqgzViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - setters and getters

- (YqgzVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[YqgzVM alloc] init];
    }
    return _viewModel;
}

@end
