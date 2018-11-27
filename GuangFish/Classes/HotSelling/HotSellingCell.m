//
//  HotSellingCell.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/16.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "HotSellingCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GuangfishNetworkingManager.h"
#import "WebViewController.h"

@interface HotSellingCell()

@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *quanMianZhiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopTypeImageView;

@end

@implementation HotSellingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([[[GuangfishNetworkingManager sharedManager] getUserCode] isEqualToString:TestUID]) {
        self.commissionLabel.hidden = YES;
        self.quanMianZhiLabel.hidden = YES;
    } else {
        self.commissionLabel.hidden = NO;
        self.quanMianZhiLabel.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(HotSellingCellVM *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
    }
    
    [self initialzieModel];
}

- (void)initialzieModel {
    RAC(self.productNameLabel, text) = [RACObserve(self.viewModel, productName) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.shopNameLabel, text) = [RACObserve(self.viewModel, shopName) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.priceLabel, text) = [RACObserve(self.viewModel, price) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.sellNumLabel, text) = [RACObserve(self.viewModel, sellNum) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.shopTypeImageView, image) = [RACObserve(self.viewModel, shopTypeImage) takeUntil:self.rac_prepareForReuseSignal];
    
    @weakify(self)
    [RACObserve(self.viewModel, reservePrice) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSString *reservePrice = x;
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:reservePrice
                                      attributes:@{
                                                   NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                   NSStrikethroughColorAttributeName:[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.00]}];
        self.reservePriceLabel.attributedText = attrStr;
        
        [self setupReservePriceLabel];
    }];
    
    [RACObserve(self.viewModel, imageURLStr) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.hotImageView sd_setImageWithURL:x];
    }];
    [RACObserve(self.viewModel, commission) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.commissionLabel setAttributedText:[self changeLabelWithText:x]];
    }];
    [RACObserve(self.viewModel, quanMianZhi) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.quanMianZhiLabel setAttributedText:[self changeLabelWithText:x]];
    }];
    [self.viewModel.openTaobaoSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[NSError class]]) {
            NSError *error = x;
            [self openTBByWeb:[error.userInfo objectForKey:@"webVM"]];
        }
    }];
    [RACObserve(self.viewModel, hideCommission) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (![[[GuangfishNetworkingManager sharedManager] getUserCode] isEqualToString:TestUID]) {
            self.commissionLabel.hidden = [x boolValue];
        }
    }];
}

-(NSMutableAttributedString*)changeLabelWithText:(NSString*)needText {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    if ([needText containsString:@":"]) {
        NSRange range = [needText rangeOfString:@":"];
        
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,range.location + 1)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(range.location + 1,needText.length - (range.location + 1))];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.37 green:0.33 blue:0.33 alpha:1.00] range:NSMakeRange(0,range.location + 1)];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00] range:NSMakeRange(range.location + 1,needText.length-(range.location + 1))];
    }
    
    return attrString;
}

- (void)openTBByWeb:(WebVM*)webVM {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    WebViewController *webViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.viewModel = webVM;
    [[self navigationController] pushViewController:webViewController animated:YES];
}

- (UINavigationController *)navigationController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (void)setupReservePriceLabel {
    CGSize priceLabelSize = [self.priceLabel.text boundingRectWithSize:CGSizeMake(300, self.priceLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.priceLabel.font} context:nil].size;
    
    CGRect rect = self.reservePriceLabel.frame;
    rect.origin.x = priceLabelSize.width + 9;
    self.reservePriceLabel.frame = rect;
}

@end
