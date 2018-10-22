//
//  HelpInfoWithImageCell.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/22.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HelpInfoWithImageCell.h"

@interface HelpInfoWithImageCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;

@end

@implementation HelpInfoWithImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(HelpInfoWithImageCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

- (void)initialzieModel {
    RAC(self.infoImageView, image) = [RACObserve(self.viewModel, infoImage) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.titleLabel, text) = [RACObserve(self.viewModel, title) takeUntil:self.rac_prepareForReuseSignal];
}

@end
