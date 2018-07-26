//
//  FriendsHomeVM.m
//  GuangFish
//
//  Created by 顾越超 on 2018/7/26.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "FriendsHomeVM.h"

@implementation FriendsHomeVM

#pragma mark - public methods

- (FriendsListVM*)getWJHFriendListVM {
    FriendsListVM *friendsListVM = [[FriendsListVM alloc] init];
    friendsListVM.friendType = FriendTypeWJH;
    return friendsListVM;
}

- (FriendsListVM*)getWLQFriendListVM {
    FriendsListVM *friendsListVM = [[FriendsListVM alloc] init];
    friendsListVM.friendType = FriendTypeWLQ;
    return friendsListVM;
}

- (FriendsListVM*)getYLQFriendListVM {
    FriendsListVM *friendsListVM = [[FriendsListVM alloc] init];
    friendsListVM.friendType = FriendTypeYLQ;
    return friendsListVM;
}

@end
