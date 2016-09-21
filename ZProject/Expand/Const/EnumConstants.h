//
//  EnumConstants.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#ifndef EnumConstants_h
#define EnumConstants_h

#import <Foundation/Foundation.h>

#pragma mark - 网络请求方式

typedef NS_ENUM(NSUInteger, ZHttpRequestMethod) {
    ZHttpRequestMethodGet       = 0,
    ZHttpRequestMethodPost      = 1,
    ZHttpRequestMethodPut       = 2,
    ZHttpRequestMethodPatch     = 3,
    ZHttpRequestMethodDelete    = 4,
};

#pragma mark -

#endif /* EnumConstants_h */
