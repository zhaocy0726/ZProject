//
//  CacheDataSource.m
//  youbei
//
//  Created by 赵春阳 on 2018/10/16.
//  Copyright © 2018 赵春阳. All rights reserved.
//

#import "CacheDataSource.h"

@implementation CacheDataSource

SINGLETON_IMPLEMENTION(CacheDataSource)

#pragma mark -
#pragma mark - init & dealloc

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark - Public Method

- (void)removeCacheWithCacheKey:(NSString *)cacheKey
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:cacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setCache:(id)data withCacheKey:(NSString *)cacheKey {
    NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:data];
    [[NSUserDefaults standardUserDefaults] setObject:cacheData forKey:cacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)loadCacheWithCacheKey:(NSString *)cacheKey
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:cacheKey]];
}

- (void)clearAllCache
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

- (void)clearAllUserDefaultsData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}

@end
