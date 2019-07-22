//
//  UIImage+fixOrientation.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIImage+fixOrientation.h"

@implementation UIImage(fixOrientation)

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// 按比例缩放,size是你要把图显示到 多大区域 ,例如:CGSizeMake(300, 400)
- (UIImage *)compressForSize:(CGSize)size {
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        NSLog(@"compressForSize_size == 0");
//        size = CGSizeMake(50, 30);
    }
    
    // 输入的image
    UIImage *newImage = nil;
    // image自身尺寸
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    // 目标尺寸
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    // 压缩比例
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    // 缩略后定位
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    // 原图片大小与需要的尺寸不相等
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        // 宽度压缩比
        CGFloat widthFactor = targetWidth / width;
        // 高度压缩比
        CGFloat heightFactor = targetHeight / height;
        // 对比宽高压缩比，选择较小的压缩比
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        }
        else {
            scaleFactor = heightFactor;
        }
        // 获取压缩以后的图片大小
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // 根据size大小开始画图
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [self drawInRect:thumbnailRect];
    // 获取画完的新图
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if (newImage == nil) {
        NSLog(@"scale image fail -- 缩放图片失败 -- 源文件：UIImageView+SDWebImage.m line 145");
    }
    // 画图结束
    UIGraphicsEndImageContext();
    return newImage;
}


// 指定宽度按比例缩放
- (UIImage *)compressForWidth:(CGFloat)defineWidth {
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        }
        else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    // TODO: 比较消耗内存, 应该尽量让图片的尺寸符合项目展示的大小, 减少图片的压缩率
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if (newImage == nil) {
        NSLog(@"scale image fail -- 缩放图片失败 -- 源文件：UIImageView+SDWebImage.m line 197");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)compressForScale:(CGFloat)scale {
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = width*scale;
    CGFloat targetHeight = height*scale;
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        }
        else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    // TODO: 比较消耗内存, 应该尽量让图片的尺寸符合项目展示的大小, 减少图片的压缩率
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if (newImage == nil) {
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *)calulateImageFileSize {
    //    NSData *data = UIImagePNGRepresentation(self);
    //    if (!data) {
    //        data = UIImageJPEGRepresentation(self, .5); //需要改成0.5才接近原图片大小
    //    }
    NSData *data = UIImageJPEGRepresentation(self, .5);
    
    double dataLength = [data length] * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    return [NSString stringWithFormat:@"image = %.3f %@", dataLength, typeArray[index]];
}


+ (UIImage *)stretchableWithImageName:(NSString *)imageName{
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    // 左端盖宽度
    NSInteger leftCapWidth = image.size.width * 0.5f;
    // 顶端盖高度
    NSInteger topCapHeight = image.size.height * 0.5f;
    // 重新赋值
    return [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
}

@end
