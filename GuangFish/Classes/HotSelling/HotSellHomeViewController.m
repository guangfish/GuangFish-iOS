//
//  HotSellHomeViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/16.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HotSellHomeViewController.h"
#import "QCSlideSwitchView.h"
#import "HotSellingViewController.h"

@interface HotSellHomeViewController ()<QCSlideSwitchViewDelegate>

@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;
@property (nonatomic, strong) NSMutableArray *controllersArray;

@end

@implementation HotSellHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialzieView];
    
    [self.viewModel getHotSellingVMs];
    [self.slideSwitchView buildUI];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - QCSlideSwitchViewDelegate

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view {
    return self.viewModel.hotSellingVMList.count;
}

- (UIViewController*)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number {
    UIStoryboard *hotSellStoryboard = [UIStoryboard storyboardWithName:@"HotSell" bundle:[NSBundle mainBundle]];
    HotSellingViewController *hotSellingViewController = [hotSellStoryboard instantiateViewControllerWithIdentifier:@"HotSellingViewController"];
    hotSellingViewController.viewModel = [self.viewModel.hotSellingVMList objectAtIndex:number];
    return hotSellingViewController;
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number {
    HotSellingVM *hotSellingVM = [self.viewModel.hotSellingVMList objectAtIndex:number];
    [hotSellingVM loadNextPageHotSellingList];
}

#pragma mark - private methods

- (void)initialzieView {
    self.slideSwitchView.topScrollView.backgroundColor = [UIColor colorWithRed:1.00 green:0.96 blue:0.98 alpha:1.00];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.tabItemNormalColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.00];
    self.slideSwitchView.tabItemSelectedColor = [UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00];
}

#pragma mark - setters and getters

- (HotSellHomeVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[HotSellHomeVM alloc] init];
    }
    return _viewModel;
}

@end
