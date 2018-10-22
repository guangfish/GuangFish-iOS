//
//  SearchGoodsReformer.h
//  GuangFish
//
//  Created by 顾越超 on 2018/7/25.
//  Copyright © 2018年 guangfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuangfishProductInfoAPIManager.h"
#import "GoodsCellVM.h"

extern NSString * const kSearchGoodsDataKeyHaveMorePage;
extern NSString * const kSearchGoodsDataKeyIfJump;
extern NSString * const kSearchGoodsDataKeyPage;
extern NSString * const kSearchGoodsDataKeyGoodsCellVMList;
extern NSString * const kSearchGoodsDataKeyMall;

@interface SearchGoodsReformer : NSObject<GuangfishAPIManagerDataReformer>

@end
