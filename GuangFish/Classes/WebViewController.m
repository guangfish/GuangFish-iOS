//
//  WebViewController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/23.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "WebViewController.h"
#import<WebKit/WebKit.h>

@interface WebViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *uuidStr;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.viewModel.urlStr]]];
    
    self.uuidStr = [self getUuid];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(self.uuidStr)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.uuidStr != nil) {
        [self.webView removeObserver:self forKeyPath:@"title" context:(__bridge void * _Nullable)(self.uuidStr)];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //网页title
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - private methods

- (NSString*)getUuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

#pragma mark - setters and getters

- (WKWebView*)webView {
    if (_webView == nil) {
        CGFloat y;
        if (self.navigationController.navigationBar.translucent) {
            y = NaviHeight;
        } else {
            y = 0;
        }
        
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, HEIGHT)];
    }
    return _webView;
}

@end
