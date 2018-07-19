//
//  HomeHeaderReusableView.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "HomeHeaderReusableView.h"
#import "GLScrollView.h"

@interface HomeHeaderReusableView()<GLScrollViewDelegate>

@property (nonatomic, strong) GLScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *paltformRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *drawButton;

@end

@implementation HomeHeaderReusableView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialzieView];
    }
    return self;
}

#pragma mark - GLScrollViewDelegate

- (void)glScrollViewDidTouchImage:(NSInteger)index {
    NSDictionary *dic = [self.viewModel.bannerDicArray objectAtIndex:index];
    NSLog(@"%@", [dic objectForKey:@"link"]);
}

#pragma mark - private methods

- (void)initialzieView {
    [self addSubview:self.bannerView];
}

- (void)initialzieModel {
    @weakify(self)
    [self.viewModel.downloadImageSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.bannerView.imageArray = self.viewModel.imageArray;
    }];
    
    [RACObserve(self.viewModel, totalMoney) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"¥%@", x];
    }];
    [RACObserve(self.viewModel, inviteReward) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.inviteRewardLabel.text = [NSString stringWithFormat:@"¥%@", x];
    }];
    [RACObserve(self.viewModel, orderMoney) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.orderMoneyLabel.text = [NSString stringWithFormat:@"¥%@", x];
    }];
    
    RAC(self.friendNumLabel, text) = [RACObserve(self.viewModel, friendNum) takeUntil:self.rac_prepareForReuseSignal];
    
    [RACObserve(self.viewModel, drawBtnEnable) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            self.drawButton.enabled = YES;
        } else {
            self.drawButton.enabled = NO;
        }
    }];
}

#pragma mark - getters and setters

- (void)setViewModel:(HomeHeaderReusableVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

- (GLScrollView*)bannerView {
    if (_bannerView == nil) {
        self.bannerView = [[GLScrollView alloc] initWithFrame:CGRectMake(0, 210, self.bounds.size.width, 150)];
        
        self.bannerView.imageInterval = 30;                //设置图片间距
        self.bannerView.leftMargin = 0;                   //设置左边图片露出屏幕的距离
        self.bannerView.topMargin = 0;                    //设置顶部边距
        self.bannerView.bottomMargin = 0;                 //设置底部边距
        self.bannerView.autoSelectPageTime = 3;
        
        self.bannerView.pageControl.frame = CGRectMake(0, self.bannerView.frame.size.height - 30, self.bannerView.frame.size.width, 30);
        
        self.bannerView.delegate = self;
    }
    return _bannerView;
}

@end
