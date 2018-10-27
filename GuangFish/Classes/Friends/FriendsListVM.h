//
//  FriendsListVM.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/26.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import "GLViewModel.h"

typedef enum {
    FriendTypeWJH = 1,
    FriendTypeYQJL
} FriendType;

@interface FriendsListVM : GLViewModel

@property (nonatomic, strong) RACSubject *requestGetFriendsSignal;
@property (nonatomic, strong) NSMutableArray *friendCellVMList;
@property (nonatomic, assign) FriendType friendType;
@property (nonatomic, strong) NSNumber *haveMore;

- (void)reloadFriendsList;
- (void)loadNextPageFriendsList;

@end
