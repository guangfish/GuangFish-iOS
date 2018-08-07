//
//  OrderCell.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/30.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "OrderCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface OrderCell()

@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;

@end

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(OrderCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

- (void)initialzieModel {
    RAC(self.productNameLabel, text) = [RACObserve(self.viewModel, productName) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.orderTimeLabel, text) = [RACObserve(self.viewModel, orderTime) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.orderStatusLabel, text) = [RACObserve(self.viewModel, orderStatus) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.commissionLabel, text) = [RACObserve(self.viewModel, commission) takeUntil:self.rac_prepareForReuseSignal];
    
    @weakify(self)
    [RACObserve(self.viewModel, imageURL) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.orderImageView sd_setImageWithURL:x];
    }];
}

@end
