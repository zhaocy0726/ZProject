//
//  WeiboRequest.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#import "BaseNetRequest.h"

@interface WeiboRequest : BaseNetRequest

// 获取授权
- (void)getAuthorize;

// 获取微博列表
- (void)getPublicWeiboList;

/**
 *  @brief 获取微博详情
 *
 *  @param detail_id   微博id
 *  @param returnBlock 返回结果
 */
- (void)getPublicWeiboDetailWithId:(id)detail_id returnBlock:(ReturnBlock)returnBlock;

@end
