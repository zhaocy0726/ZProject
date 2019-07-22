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

/// MARK: 网络请求方式
typedef NS_ENUM(NSUInteger, ENUM_ZHttpRequestMethod) {
    /** 增加数据 */
    ENUM_ZHttpRequestMethodPost = 1,
    /** 获取数据 */
    ENUM_ZHttpRequestMethodGet,
    /** 修改数据 */
    ENUM_ZHttpRequestMethodPut,
    /** 删除数据 */
    ENUM_ZHttpRequestMethodDelete,
};

/// MARK: 上传文件类型
typedef NS_ENUM(NSUInteger, ENUM_UploadFileType) {
    /** 图片 */
    ENUM_UploadFileTypeImage = 0,
    /** 视频 */
    ENUM_UploadFileTypeVideo = 1,
};

#endif /* EnumConstants_h */
