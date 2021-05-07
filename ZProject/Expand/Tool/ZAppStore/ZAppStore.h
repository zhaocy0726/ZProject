//
//  ZAppStore.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/27.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 内购支付状态
typedef NS_ENUM(NSUInteger, IAPPayState) {
    IAPPayStateCancel,
    IAPPayStateSuccess,
    IAPPayStateFail,
};

/**
 内购支付结果
 
 @param state 支付结果
 @param receipt 支付结果验证
 @param errorMsg 错误信息
 */
typedef void(^PayResultBlock)(IAPPayState state, NSString *receipt, NSString *errorMsg);

@interface ZAppStore : NSObject

+ (instancetype)manager;

// 开始监听
- (void)startManager;
// 结束监听
- (void)stopManager;

/**
 苹果内购

 @param productId  商品id
 @param orderId  订单id
 */
- (void)buyProductWithId:(NSString *)productId orderId:(NSString *)orderId result:(PayResultBlock)result;

@end
