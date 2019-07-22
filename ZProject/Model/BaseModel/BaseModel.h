//
//  BaseModel.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/22.
//  Copyright © 2016年 Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject <NSCoding>

/**
 模型转字典
 
 @return 字典
 */
- (NSMutableDictionary *)createDictionayFromModelProperties;

@end
