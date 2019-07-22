//
//  LocationManager.h
//  youbei
//
//  Created by 赵春阳 on 2019/4/2.
//  Copyright © 2019 赵春阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject

/**
 开始定位
 
 @param cnBlock 成功回调
 */
+ (void)startUpdatingLocationWithBlock:(void (^)(NSString *city))block;

@end

