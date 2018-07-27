//
//  FriendCell.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "FriendCell.h"

@interface FriendCell()

@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *ifrewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation FriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(FriendCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

- (void)initialzieModel {
    RAC(self.timeLabel, text) = RACObserve(self.viewModel, inviteTime);
    RAC(self.statusLabel, text) = RACObserve(self.viewModel, status);
    
    @weakify(self)
    [RACObserve(self.viewModel, mobile) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.mobileLabel.text = [NSString stringWithFormat:@"我的逛友:%@", x];
    }];
    
    [RACObserve(self.viewModel, rewardMoney) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.rewardMoneyLabel.text = [NSString stringWithFormat:@"邀请奖励:¥%@", x];
    }];
    
    [RACObserve(self.viewModel, ifreward) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.ifrewardLabel.text = [NSString stringWithFormat:@"奖励状态:%@", x];
    }];
}

@end
