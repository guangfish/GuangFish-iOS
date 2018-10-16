//
//  ProductSearchReformer.h
//  GuangFish
//
//  Created by 顾越超 on 2018/10/16.
//  Copyright © 2018 guangfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuangfishProductSearchAPIManager.h"
#import "HotSellingCellVM.h"

extern NSString * const kProductSearchDataKeyHaveMorePage;
extern NSString * const kProductSearchDataKeyPage;
extern NSString * const kProductSearchDataKeyHotSellingCellVMList;

@interface ProductSearchReformer : NSObject<GuangfishAPIManagerDataReformer>

@end
