//
//  UIView+FrameHelper.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(FrameHelper)

@property (assign, nonatomic) CGFloat	top;
@property (assign, nonatomic) CGFloat	bottom;
@property (assign, nonatomic) CGFloat	left;
@property (assign, nonatomic) CGFloat	right;

@property (assign, nonatomic) CGPoint	offset;
@property (assign, nonatomic) CGPoint	position;

@property (assign, nonatomic) CGFloat	x;
@property (assign, nonatomic) CGFloat	y;
@property (assign, nonatomic) CGFloat	w;
@property (assign, nonatomic) CGFloat	h;

@property (assign, nonatomic) CGFloat	width;
@property (assign, nonatomic) CGFloat	height;
@property (assign, nonatomic) CGSize	size;

@property (assign, nonatomic) CGFloat	centerX;
@property (assign, nonatomic) CGFloat	centerY;
@property (assign, nonatomic) CGPoint	origin;
@property (readonly, nonatomic) CGPoint	boundsCenter;

- (void)setPosition:(CGPoint)point atAnchorPoint:(CGPoint)anchorPoint;

/// MARK: 根据需求的尺寸缩放图片
- (UIImage *)compressForImage:(UIImage *)image scaleToSize:(CGSize)size;

/// MARK: 根据比例缩放图片
- (UIImage *)compressForImage:(UIImage *)image scale:(CGFloat)scale;

@end
