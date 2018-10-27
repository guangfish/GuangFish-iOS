//
//  HotSerchViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/10/27.
//  Copyright © 2018 guangfish. All rights reserved.
//

#define BUTTONINTERVAL 10
#define BUTTONSIDERETAIN 36
#define HotSearchButtonTag 200

#import "HotSerchViewController.h"
#import "GoodsListViewController.h"

@interface HotSerchViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *hotSearchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

- (IBAction)searchTextFieldEditEnd:(id)sender;
@end

@implementation HotSerchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialzieView];
    
    [self.viewModel getHotWord];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - actions

- (IBAction)searchTextFieldEditEnd:(id)sender {
    [self showGoodsList];
}

#pragma mark - private methods

- (void)initialzieView {
    RAC(self.viewModel, searchStr) = self.searchTextField.rac_textSignal;
    
    @weakify(self);
    self.cancelButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self dismissViewControllerAnimated:NO completion:nil];
        return [RACSignal empty];
    }];
    
    [self.viewModel.requestGetHotWordSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[NSError class]]) {
            [self showTextHud:[(NSError *)x domain]];
        } else {
            [self hotSearchViewContent];
        }
    }];
}

- (void)hotSearchViewContent {
    NSInteger width = 0;
    NSInteger height = 0;
    
    for (int i = 0; i < self.viewModel.hotWordArray.count; i++) {
        __strong NSString *hotSearch = [self.viewModel.hotWordArray objectAtIndex:i];
        if (hotSearch.length > 23) {
            hotSearch = [NSString stringWithFormat:@"%@...", [hotSearch substringToIndex:22]];
        }
        CGSize size = [self sizeOfStr:hotSearch font:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(280, 21)];
        if (width + size.width + BUTTONSIDERETAIN > _hotSearchView.frame.size.width) {
            width = 0;
            height += 40;
        }
        
        //        NSLog(@"========================%d,%lf", i, width);
        
        CGRect rect = CGRectMake(width, height, size.width + BUTTONSIDERETAIN, 28);
        UIButton *button = [self searchButton:hotSearch tag:(HotSearchButtonTag + i) frame:rect];
        [_hotSearchView addSubview:button];
        width += (size.width + BUTTONINTERVAL + BUTTONSIDERETAIN);
    }
    CGRect rect = _hotSearchView.frame;
    rect.size.height = height + 40;
    _hotSearchView.frame = rect;
}

- (UIButton *)searchButton:(NSString *)titleStr tag:(NSInteger)tag frame:(CGRect)rect {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setBackgroundColor:[UIColor colorWithRed:1.00 green:0.96 blue:0.98 alpha:1.00]];
    [button setTitle:titleStr forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button setTitleColor:[UIColor colorWithRed:0.99 green:0.68 blue:0.82 alpha:1.00] forState:UIControlStateNormal];
    button.layer.cornerRadius = 3.0f;
    button.layer.masksToBounds = YES;
    
    [button addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    return button;
}

- (CGSize)sizeOfStr:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRange allRange = [string rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:allRange];
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size = [attrStr boundingRectWithSize:maxSize
                                        options:options
                                        context:nil].size;
    return size;
}

- (void)searchPressed:(UIButton *)sender {
    [self hideKeyBoard];
    if (sender.tag >= HotSearchButtonTag) {
        self.searchTextField.text = [self.viewModel.hotWordArray objectAtIndex:(sender.tag - HotSearchButtonTag)];
        self.viewModel.searchStr = self.searchTextField.text;
    }
    [self showGoodsList];
}

- (void)showGoodsList {
    UIStoryboard *searchStoryboard = [UIStoryboard storyboardWithName:@"Search" bundle:[NSBundle mainBundle]];
    GoodsListViewController *goodsListViewController = [searchStoryboard instantiateViewControllerWithIdentifier:@"GoodsListViewController"];
    goodsListViewController.viewModel = [self.viewModel getGoodsListVM];
    [self showViewController:goodsListViewController sender:nil];
}

#pragma mark - setters and getters

- (HotSearchVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [[HotSearchVM alloc] init];
    }
    return _viewModel;
}

@end
