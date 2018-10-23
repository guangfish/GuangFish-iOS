//
//  HelpInfoWithTitleCell.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/23.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HelpInfoWithTitleCell.h"

@interface HelpInfoWithTitleCell()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@end

@implementation HelpInfoWithTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(HelpInfoWithTitleCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

- (void)initialzieModel {
    RAC(self.questionLabel, text) = [RACObserve(self.viewModel, question) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.answerLabel, text) = [RACObserve(self.viewModel, answer) takeUntil:self.rac_prepareForReuseSignal];
}

@end
