//
//  HelpViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/22.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HelpViewController.h"
#import "QCSlideSwitchView.h"
#import "HelpInfoWithImageViewController.h"
#import "HelpInfoViewController.h"

@interface HelpViewController ()<QCSlideSwitchViewDelegate>

@property (nonatomic, strong) NSMutableArray *controllersArray;
@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;
@property (weak, nonatomic) IBOutlet UIButton *tbsyButton;
@property (weak, nonatomic) IBOutlet UIButton *jdsyButton;
@property (weak, nonatomic) IBOutlet UIButton *txxzButton;
@property (weak, nonatomic) IBOutlet UIButton *cjwtButton;
@property (weak, nonatomic) IBOutlet UIView *tbsySelectedView;
@property (weak, nonatomic) IBOutlet UIView *jdsySelectedView;
@property (weak, nonatomic) IBOutlet UIView *txxzSelectedView;
@property (weak, nonatomic) IBOutlet UIView *cjwtSelectedView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.slideSwitchView.isTopHide = YES;
    self.slideSwitchView.slideSwitchViewDelegate = self;
    [self.slideSwitchView buildUI];
    
    [self initialzieModel];
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
    return self.controllersArray.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number {
    return [self.controllersArray objectAtIndex:number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number {
    if (number == 0) {
        [self chooseTbsy];
    } else if (number == 1) {
        [self chooseJdsy];
    } else if (number == 2) {
        [self chooseTxxz];
    }
}

#pragma mark - private methods

- (void)initialzieModel {
    @weakify(self)
    self.tbsyButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        [self chooseTbsy];
        return [RACSignal empty];
    }];
    
    self.jdsyButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        [self chooseJdsy];
        return [RACSignal empty];
    }];
    
    self.txxzButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        [self chooseTxxz];
        return [RACSignal empty];
    }];
}

- (void)chooseTbsy {
    [self.tbsyButton setTitleColor:[UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00] forState:(UIControlStateNormal)];
    [self.jdsyButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.txxzButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.cjwtButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    self.tbsySelectedView.hidden = NO;
    self.jdsySelectedView.hidden = YES;
    self.txxzSelectedView.hidden = YES;
    self.cjwtSelectedView.hidden = YES;
    [self.slideSwitchView switchByTag:0];
}

- (void)chooseJdsy {
    [self.tbsyButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.jdsyButton setTitleColor:[UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00] forState:(UIControlStateNormal)];
    [self.txxzButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.cjwtButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    self.tbsySelectedView.hidden = YES;
    self.jdsySelectedView.hidden = NO;
    self.txxzSelectedView.hidden = YES;
    self.cjwtSelectedView.hidden = YES;
    [self.slideSwitchView switchByTag:1];
}

- (void)chooseTxxz {
    [self.tbsyButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.jdsyButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    [self.txxzButton setTitleColor:[UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00] forState:(UIControlStateNormal)];
    [self.cjwtButton setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:(UIControlStateNormal)];
    self.tbsySelectedView.hidden = YES;
    self.jdsySelectedView.hidden = YES;
    self.txxzSelectedView.hidden = NO;
    self.cjwtSelectedView.hidden = YES;
    [self.slideSwitchView switchByTag:2];
}

#pragma mark - setters and getters

- (HelpVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[HelpVM alloc] init];
    }
    return _viewModel;
}

- (NSMutableArray*)controllersArray {
    if (_controllersArray == nil) {
        self.controllersArray = [[NSMutableArray alloc] initWithCapacity:3];
        
        UIStoryboard *mineStoryboard = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
        HelpInfoWithImageViewController *tbsyViewController = [mineStoryboard instantiateViewControllerWithIdentifier:@"HelpInfoWithImageViewController"];
        tbsyViewController.title = @"淘宝使用";
        tbsyViewController.viewModel = [self.viewModel getTbsyVM];
        
        HelpInfoWithImageViewController *jdsyViewController = [mineStoryboard instantiateViewControllerWithIdentifier:@"HelpInfoWithImageViewController"];
        jdsyViewController.title = @"京东使用";
        jdsyViewController.viewModel = [self.viewModel getJdsyVM];
        
        HelpInfoViewController *txxzViewController = [mineStoryboard instantiateViewControllerWithIdentifier:@"HelpInfoViewController"];
        txxzViewController.title = @"提现须知";
        txxzViewController.viewModel = [self.viewModel getTxxzVM];
        
        [self.controllersArray addObjectsFromArray:@[tbsyViewController, jdsyViewController, txxzViewController]];
    }
    return _controllersArray;
}

@end
