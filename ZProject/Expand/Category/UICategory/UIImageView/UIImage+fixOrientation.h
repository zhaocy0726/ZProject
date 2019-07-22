//
//  UIImage+fixOrientation.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(fixOrientation)

// 修复方向
- (UIImage *)fixOrientation;
/** 按比例缩放,size是你要把图显示到 多大区域 ,例如:CGSizeMake(300, 400) */
- (UIImage *)compressForSize:(CGSize)size;
/** 指定宽度按比例缩放 */
- (UIImage *)compressForWidth:(CGFloat)defineWidth;
/** 比例缩放 */
- (UIImage *)compressForScale:(CGFloat)scale;
/** 获取图片大小 */
- (NSString *)calulateImageFileSize;


/**
 拉伸图片

 @param imageName 图片名
 @return 目标对象
 */
+ (UIImage *)stretchableWithImageName:(NSString *)imageName;

@end
