//
//  CacheDataSource.h
//  youbei
//
//  Created by 赵春阳 on 2018/10/16.
//  Copyright © 2018 赵春阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheDataSource : NSObject

SINGLETON_INTERFACE(CacheDataSource)

/* 本地缓存基本信息 */

// 保存缓存数据

/**
 保存缓存数据
 
 @param data      缓存的数据
 @param cacheKey  key
 */
- (void)setCache:(id)data withCacheKey:(NSString *)cacheKey;

/**
 删除缓存数据

 @param cacheKey key
 */
- (void)removeCacheWithCacheKey:(NSString *)cacheKey;

/**
 读取缓存数据
 
 @param cacheKey  key
 @return data     缓存的数据
 */
- (id)loadCacheWithCacheKey:(NSString *)cacheKey;

/**
 清除持久域
 */
- (void)clearAllCache;

/**
 *  清除所有的存储本地的数据
 */
- (void)clearAllUserDefaultsData;

@end

