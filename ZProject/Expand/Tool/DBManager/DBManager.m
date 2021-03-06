//
//  DBManager.m
//  youbei
//
//  Created by 赵春阳 on 2019/3/6.
//  Copyright © 2019 赵春阳. All rights reserved.
//

#import "DBManager.h"

#import "FMDB.h"

@implementation DBManager

SINGLETON_IMPLEMENTION(DBManager)

- (void)fetchDBComplete:(void(^)(NSArray *array))complete
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"adult_changing" ofType:@"db"]; // 获取数据库文件路径
        FMDatabase *db = [FMDatabase databaseWithPath:path];
        NSMutableArray *arrResult = [[NSMutableArray alloc] initWithCapacity:3];
        if ([db open]) {

            FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM \"adult_changing\""]];
            NSMutableDictionary *dict = result.columnNameToIndexMap;
            NSLog(@"columnName %@", dict);
            while ([result next]) {
                //根据字段名，获取记录的值，存储到字典中
                NSDictionary *dic = [result resultDictionary];
                [arrResult addObject:dic];
            }
            [db close];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(arrResult);
        });
    });
}


/**
 获取宝宝生长分析
 
 @param month 月份
 @param complete 回调
 */
- (void)fetchGrowthStageWithMonth:(NSInteger)month complete:(void(^)(NSMutableDictionary *model))complete
{
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"growth_stage" ofType:@"db"]; // 获取数据库文件路径
        FMDatabase *db = [FMDatabase databaseWithPath:path]; // 初始化数据库
        
        NSMutableDictionary *growthStage = [NSMutableDictionary new]; // 初始化今日变化模型
        if ([db open]) {
            FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM \"growth_stage_desc\" WHERE \"month\" == %ld;", month]];
            
            while ([result next]) {
                // 如果有获取的结果，根据字段名，获取记录的值，存储到字典中
                growthStage[@"seqId"] = [result stringForColumn:@"id"];
                growthStage[@"stageDescription"] = [result stringForColumn:@"description"];
                growthStage[@"month"] = [result stringForColumn:@"month"];
            }
            
            [db close];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(growthStage); // 返回结果
        });
    });
}

@end
