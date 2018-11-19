//
//  MineHomeViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/11/11.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "MineHomeViewController.h"
#import "FriendsHomeViewController.h"
#import "OrderListHomeViewController.h"
#import "GLScrollView.h"
#import "WebViewController.h"
#import "GuangfishNetworkingManager.h"

@interface MineHomeViewController ()<GLScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeCopyButton;
@property (weak, nonatomic) IBOutlet UIButton *codeCopyButton2;
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *paltformRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *drawButton;
@property (weak, nonatomic) IBOutlet UIButton *DrawRecordButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalBuySaveLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *bannerCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *moneyInfoCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *orderCell;
@property (nonatomic, strong) GLScrollView *bannerView;

@end

@implementation MineHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialzieView];
    [self initialzieModel];
    [self.viewModel getUserData];
    [self.viewModel getBanner];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self setStatusBarBackgroundColor:[UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00]];
    
    [self.viewModel getDrawStats];
}

#pragma mark - GLScrollViewDelegate

- (void)glScrollViewDidTouchImage:(NSInteger)index {
    NSDictionary *dic = [self.viewModel.bannerDicArray objectAtIndex:index];
    
    NSString *link = [dic objectForKey:@"link"];
    if (link.length == 0) {
        return;
    }
    
    UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    WebViewController *webViewController = [homeStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    WebVM *webVM = [[WebVM alloc] init];
    webVM.urlStr = link;
    webViewController.viewModel = webVM;
    [self showViewController:webViewController sender:nil];
}

#pragma mark - UITableviewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        [self showFriendsVC];
    } else if (indexPath.row == 5) {
        [self showOrderVC];
    } else if (indexPath.row == 11) {
        [self.viewModel cleanMemory];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    if ([[[GuangfishNetworkingManager sharedManager] getUserCode] isEqualToString:TestUID] && cell == self.moneyInfoCell) {
        return 0;
    }
    if (![[[GuangfishNetworkingManager sharedManager] getUserCode] isEqualToString:TestUID] && cell == self.bannerCell) {
        return 0;
    }
    if (![[[GuangfishNetworkingManager sharedManager] getUserCode] isEqualToString:TestUID] && cell == self.orderCell) {
        return 0;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private methods

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)initialzieView {
    [self.bannerCell addSubview:self.bannerView];
    
    self.logoutButton.layer.borderWidth = 1.0f;
    self.logoutButton.layer.borderColor = [UIColor colorWithRed:0.94 green:0.57 blue:0.71 alpha:1.00].CGColor;
    self.logoutButton.layer.cornerRadius = 16.0f;
    self.logoutButton.layer.masksToBounds = YES;
}

- (void)initialzieModel {
    RAC(self.mobileLabel, text) = RACObserve(self.viewModel, mobile);
    RAC(self.totalMoneyLabel, text) = RACObserve(self.viewModel, totalMoney);
    RAC(self.orderMoneyLabel, text) = RACObserve(self.viewModel, orderMoney);
    RAC(self.paltformRewardLabel, text) = RACObserve(self.viewModel, paltformReward);
    RAC(self.versionLabel, text) = RACObserve(self.viewModel, version);
    RAC(self.totalBuySaveLabel, text) = RACObserve(self.viewModel, totalBuySave);
    
    @weakify(self);
    [self.viewModel.inviteCodeSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self hideActivityHud];
        if (![x isKindOfClass:[NSError class]]) {
            [self showTextHud:x];
        }
    }];
    
    [self.viewModel.requestGetBannerSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.bannerView.imageArray = self.viewModel.imageArray;
        if (self.bannerView.imageArray.count <= 1) {
            self.bannerView.pageControl.hidden = YES;
        } else {
            self.bannerView.pageControl.hidden = NO;
        }
    }];
    
    self.codeCopyButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self.viewModel inviteCodeCopy];
        return [RACSignal empty];
    }];
    
    self.codeCopyButton2.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self.viewModel inviteCodeCopy];
        return [RACSignal empty];
    }];
    
    [self.viewModel.cleanMemorySignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (![x isKindOfClass:[NSError class]]) {
            [self showTextHud:x];
        }
    }];
    
    self.drawButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if ([self.viewModel.hasBindAccount boolValue]) {
            if ([self.viewModel.drawBtnEnable boolValue]) {
                [self canDraw:YES withErrorMsg:nil];
            } else {
                [self canDraw:NO withErrorMsg:self.viewModel.reason];
            }
        } else {
            [self hasNotBindAccount];
        }
        return [RACSignal empty];
    }];
    
    self.DrawRecordButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self performSegueWithIdentifier:@"ShowDrawRecordSegue" sender:nil];
        return [RACSignal empty];
    }];
    
    self.logoutButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self.viewModel logout];
        
        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UINavigationController *loginChooseNavigationViewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginChooseNavigationViewController"];
        [UIApplication sharedApplication].keyWindow.rootViewController = loginChooseNavigationViewController;
        
        return [RACSignal empty];
    }];
}

- (void)canDraw:(BOOL)canDraw withErrorMsg:(NSString *)errorMsg {
    if (canDraw) {
        [self performSegueWithIdentifier:@"ShowDrawSegue" sender:nil];
    } else {
        [self showTextHud:errorMsg];
    }
}

- (void)hasNotBindAccount {
    [self performSegueWithIdentifier:@"ShowBindAccountSegue" sender:nil];
}

- (void)showFriendsVC {
    UIStoryboard *friendsStoryboard = [UIStoryboard storyboardWithName:@"Friends" bundle:[NSBundle mainBundle]];
    FriendsHomeViewController *friendsHomeViewController = [friendsStoryboard instantiateViewControllerWithIdentifier:@"FriendsHomeViewController"];
    [self showViewController:friendsHomeViewController sender:nil];
}

- (void)showOrderVC {
    UIStoryboard *searchStoryboard = [UIStoryboard storyboardWithName:@"Search" bundle:[NSBundle mainBundle]];
    OrderListHomeViewController *orderListHomeViewController = [searchStoryboard instantiateViewControllerWithIdentifier:@"OrderListHomeViewController"];
    [self showViewController:orderListHomeViewController sender:nil];
}

#pragma mark - getters and setters

- (MineHomeVM*)viewModel {
    if (_viewModel == nil) {
        self.viewModel = [MineHomeVM new];
    }
    return _viewModel;
}

- (GLScrollView*)bannerView {
    if (_bannerView == nil) {
        self.bannerView = [[GLScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 151)];
        
        self.bannerView.backgroundColor = [UIColor clearColor];
        
        self.bannerView.imageInterval = 15;               //设置图片间距
        self.bannerView.leftMargin = 0;                   //设置左边图片露出屏幕的距离
        self.bannerView.topMargin = 8;                    //设置顶部边距
        self.bannerView.bottomMargin = 16;                 //设置底部边距
        self.bannerView.autoSelectPageTime = 3;
        self.bannerView.imageViewCornerRadius = 10;
        
        self.bannerView.imageShadowOffset = CGSizeMake(1, 3);
        self.bannerView.imageShadowOpacity = 0.3;
        self.bannerView.imageShadowRadius = 3;
        
        self.bannerView.pageControl.frame = CGRectMake(0, self.bannerView.frame.size.height - 30, self.bannerView.frame.size.width, 30);
        
        self.bannerView.delegate = self;
    }
    return _bannerView;
}

@end
