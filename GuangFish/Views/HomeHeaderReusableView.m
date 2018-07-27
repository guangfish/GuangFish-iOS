//
//  HomeHeaderReusableView.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/12.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "HomeHeaderReusableView.h"
#import "GLScrollView.h"
#import "WebViewController.h"

@interface HomeHeaderReusableView()<GLScrollViewDelegate>

@property (nonatomic, strong) GLScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *paltformRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *drawButton;
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;
@property (weak, nonatomic) IBOutlet UIButton *orderRewardButton;

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
    UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webViewController = [homeStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    WebVM *webVM = [[WebVM alloc] init];
    webVM.urlStr = [dic objectForKey:@"link"];
    webViewController.viewModel = webVM;
    [[self viewController] showViewController:webViewController sender:nil];
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
    
    self.drawButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if ([self.viewModel.drawBtnEnable boolValue]) {
            [self.delegate canDraw:YES withErrorMsg:nil];
        } else {
            [self.delegate canDraw:NO withErrorMsg:self.viewModel.reason];
        }
        return [RACSignal empty];
    }];
    
    self.friendsButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [[self viewController] performSegueWithIdentifier:@"ShowFriendsHomeSegue" sender:nil];
        return [RACSignal empty];
    }];
    
    self.orderRewardButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [[self viewController] performSegueWithIdentifier:@"ShowOrderRewardSegue" sender:nil];
        return [RACSignal empty];
    }];
}

- (UIViewController *)viewController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
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
