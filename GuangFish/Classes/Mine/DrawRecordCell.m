//
//  DrawRecordCell.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/17.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "DrawRecordCell.h"

@interface DrawRecordCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation DrawRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(DrawRecordCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

- (void)initialzieModel {
    RAC(self.timeLabel, text) = [RACObserve(self.viewModel, time) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.moneyLabel, text) = [RACObserve(self.viewModel, money) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self, backgroundColor) = [RACObserve(self.viewModel, bgColor) takeUntil:self.rac_prepareForReuseSignal];
}

@end
