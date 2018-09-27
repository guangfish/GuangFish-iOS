//
//  TabBarController.m
//  GuangFish
//
//  Created by 顾越超 on 2018/9/26.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:0.95 green:0.18 blue:0.43 alpha:1.00], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    UIStoryboard *searchStoryboard = [UIStoryboard storyboardWithName:@"Search" bundle:[NSBundle mainBundle]];
    UIStoryboard *hotSellStoryboard = [UIStoryboard storyboardWithName:@"HotSell" bundle:[NSBundle mainBundle]];
    UIStoryboard *friendsStoryboard = [UIStoryboard storyboardWithName:@"Friends" bundle:[NSBundle mainBundle]];
    UIStoryboard *mineStoryboard = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    UINavigationController *searchNavigationController = [searchStoryboard instantiateViewControllerWithIdentifier:@"SearchNavigationController"];
    UINavigationController *hotSellNavigationController = [hotSellStoryboard instantiateViewControllerWithIdentifier:@"HotSellNavigationController"];
    UINavigationController *friendsNavigationController = [friendsStoryboard instantiateViewControllerWithIdentifier:@"FriendsNavigationController"];
    UINavigationController *mineNavigationController = [mineStoryboard instantiateViewControllerWithIdentifier:@"MineNavigationController"];
    
    self.viewControllers = @[searchNavigationController, hotSellNavigationController, friendsNavigationController, mineNavigationController];
    
    UITabBarItem* itemSearch = [self.tabBar.items objectAtIndex:0];
    itemSearch.title = @"搜索";
    [itemSearch setSelectedImage:[[UIImage imageNamed:@"tabbar_home_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [itemSearch setImage:[[UIImage imageNamed:@"tabbar_home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem* itemHot = [self.tabBar.items objectAtIndex:1];
    itemHot.title = @"热卖";
    [itemHot setSelectedImage:[[UIImage imageNamed:@"tabbar_news_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [itemHot setImage:[[UIImage imageNamed:@"tabbar_news.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem* itemFriends = [self.tabBar.items objectAtIndex:2];
    itemFriends.title = @"逛友";
    [itemFriends setSelectedImage:[[UIImage imageNamed:@"tabbar_msg_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [itemFriends setImage:[[UIImage imageNamed:@"tabbar_msg.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem* itemMine = [self.tabBar.items objectAtIndex:3];
    itemMine.title = @"我的";
    [itemMine setSelectedImage:[[UIImage imageNamed:@"tabbar_set_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [itemMine setImage:[[UIImage imageNamed:@"tabbar_set.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
