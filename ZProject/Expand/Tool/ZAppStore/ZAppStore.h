//
//  ZAppStore.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/27.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZAppStore : NSObject

+ (instancetype)shareInstance;

/**
 苹果内购

 @param productId      商品id
 @param viewController 控制器
 */
- (void)buyProductWithId:(NSString *)productId viewController:(UIViewController *)viewController;

@end
