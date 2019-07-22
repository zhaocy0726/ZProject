//
//  DBManager.h
//  youbei
//
//  Created by 赵春阳 on 2019/3/6.
//  Copyright © 2019 赵春阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

SINGLETON_INTERFACE(DBManager)

/**
 获取数据库表

 @param complete 回调
 */
- (void)fetchDBComplete:(void(^)(NSArray *array))complete;

/**
 获取宝宝生长分析

 @param month 月份
 @param complete 回调
 */
- (void)fetchGrowthStageWithMonth:(NSInteger)month complete:(void(^)(YBGrowthStageModel *model))complete;

/**
 获取宝宝今日变化
 
 @param day 时间标记
 @param complete 回调
 */
- (void)fetchBabyChangingWithDay:(NSInteger)day complete:(void(^)(YBBabyChangingModel *model))complete;

/**
 获取怀孕宝宝今日变化
 
 @param day 时间标记
 @param complete 回调
 */
- (void)fetchPregnantBabyChangingWithDay:(NSInteger)day complete:(void(^)(YBBabyChangingModel *model))complete;

@end

