//
//  HelpInfoCell.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/22.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HelpInfoCell.h"

@interface HelpInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation HelpInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(HelpInfoCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

- (void)initialzieModel {
    RAC(self.contentLabel, text) = [RACObserve(self.viewModel, content) takeUntil:self.rac_prepareForReuseSignal];
    
    @weakify(self);
    [RACObserve(self.viewModel, redRangeStrList) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self changeText:x];
    }];
}

- (void)changeText:(NSArray*)rangeStrList {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.viewModel.content];
    for (NSString *str in rangeStrList) {
        NSArray *array = [str componentsSeparatedByString:@","];
        NSRange range = NSMakeRange([array.firstObject integerValue], [array.lastObject integerValue]);
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00] range:range];
    }
    [self.contentLabel setAttributedText:attrString];
}

@end
