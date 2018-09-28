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
    [itemSearch setSelectedImage:[[UIImage imageNamed:@"img_tabbar_search_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [itemSearch setImage:[[UIImage imageNamed:@"img_tabbar_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem* itemHot = [self.tabBar.items objectAtIndex:1];
    itemHot.title = @"热卖";
    [itemHot setSelectedImage:[[UIImage imageNamed:@"img_tabbar_hot_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [itemHot setImage:[[UIImage imageNamed:@"img_tabbar_hot"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem* itemFriends = [self.tabBar.items objectAtIndex:2];
    itemFriends.title = @"逛友";
    [itemFriends setSelectedImage:[[UIImage imageNamed:@"img_tabbar_friends_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [itemFriends setImage:[[UIImage imageNamed:@"img_tabbar_friends"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem* itemMine = [self.tabBar.items objectAtIndex:3];
    itemMine.title = @"我的";
    [itemMine setSelectedImage:[[UIImage imageNamed:@"img_tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [itemMine setImage:[[UIImage imageNamed:@"img_tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
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
