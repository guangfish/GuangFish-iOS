//
//  FriendCell.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "FriendCell.h"
#import "GuangfishNetworkingManager.h"

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
    
    if ([[[GuangfishNetworkingManager sharedManager] getUserCode] isEqualToString:TestUID]) {
        self.rewardMoneyLabel.hidden = YES;
    } else {
        self.rewardMoneyLabel.hidden = NO;
    }
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
    RAC(self.timeLabel, text) = [RACObserve(self.viewModel, inviteTime) takeUntil:self.rac_prepareForReuseSignal];
    
    @weakify(self)
    [RACObserve(self.viewModel, mobile) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.mobileLabel.text = [NSString stringWithFormat:@"我的逛友:%@", x];
    }];
    
    [RACObserve(self.viewModel, rewardMoney) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.rewardMoneyLabel setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@"邀请奖励:¥%@", x] withChangeColor:nil]];
    }];
    
    [RACObserve(self.viewModel, status) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.statusLabel setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@"激活状态:%@", x] withChangeColor:self.viewModel.statusColor]];
    }];
    
    [RACObserve(self.viewModel, ifreward) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.ifrewardLabel setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@"奖励状态:%@", x] withChangeColor:self.viewModel.ifrewardColor]];
    }];
    
    [RACObserve(self.viewModel, backgroundColor) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.backgroundColor = x;
    }];
}

-(NSMutableAttributedString*)changeLabelWithText:(NSString*)needText withChangeColor:(UIColor*)color {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    if ([needText containsString:@":"]) {
        NSRange range = [needText rangeOfString:@":"];
        if (color == nil) {
            color = [UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00];
        }
        [attrString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(range.location + 1,needText.length-(range.location + 1))];
    }
    return attrString;
}

@end
