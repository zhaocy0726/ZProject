//
//  BaseNetRequest.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetRequest : NSObject

// 输入字符编码转义（主要用于搜索）
- (NSString *)encodeToPercentEscapeString:(NSString *)string;

@end
