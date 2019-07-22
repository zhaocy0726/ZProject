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

@end

