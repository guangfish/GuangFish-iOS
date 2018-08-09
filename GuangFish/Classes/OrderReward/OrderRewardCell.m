//
//  OrderRewardCell.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/27.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "OrderRewardCell.h"

@interface OrderRewardCell()

@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderRewardRateLabel;

@end

@implementation OrderRewardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(OrderRewardCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

- (void)initialzieModel {
    RAC(self, backgroundColor) = [RACObserve(self.viewModel, bgColor) takeUntil:self.rac_prepareForReuseSignal];
    
    @weakify(self)
    [RACObserve(self.viewModel, mobile) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.mobileLabel.text = [NSString stringWithFormat:@"我的逛友:%@", x];
    }];
    
    [RACObserve(self.viewModel, orderReward) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.orderRewardLabel setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@"订单奖励:¥%@", x]]];
    }];
    
    [RACObserve(self.viewModel, commission) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.commissionLabel setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@"订单返现:¥%@", x]]];
    }];
    
    [RACObserve(self.viewModel, orderRewardRate) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.orderRewardRateLabel setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@"奖励比例:%@%%", x]]];
    }];
}

-(NSMutableAttributedString*)changeLabelWithText:(NSString*)needText {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    if ([needText containsString:@":"]) {
        NSRange range = [needText rangeOfString:@":"];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.93 green:0.06 blue:0.32 alpha:1.00] range:NSMakeRange(range.location + 1,needText.length-(range.location + 1))];
    }
    
    return attrString;
}

@end
