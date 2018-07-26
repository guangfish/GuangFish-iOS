//
//  FriendsHomeVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/26.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"
#import "FriendsListVM.h"

@interface FriendsHomeVM : GLViewModel

- (FriendsListVM*)getWJHFriendListVM;
- (FriendsListVM*)getWLQFriendListVM;
- (FriendsListVM*)getYLQFriendListVM;

@end
