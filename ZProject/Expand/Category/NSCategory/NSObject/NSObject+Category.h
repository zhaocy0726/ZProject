//
//  NSObject+Category.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/13.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Category)

/** float函数转number */
- (NSNumber *)floatToNumber:(CGFloat)floatNumber;
/** 获取与设置设备唯一标识符 */
- (void)deviceUUID;
/** 获取当前最上面的控制器 */
- (UIViewController *)getCurrentVC;
- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC;

/**
 两个日期对比差
 
 unit 要比较的时间单位,常用如下,可以同时传：
 *    NSCalendarUnitDay : 天
 *    NSCalendarUnitYear : 年
 *    NSCalendarUnitMonth : 月
 *    NSCalendarUnitHour : 时
 *    NSCalendarUnitMinute : 分
 *    NSCalendarUnitSecond : 秒
 */
- (NSDateComponents *)compareDateWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate unit:(NSCalendarUnit)unit;

@end
