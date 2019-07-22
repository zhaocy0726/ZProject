//
//  UIView+Nib.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(Nib)

+ (UINib *)nib;
+ (instancetype)loadFromNib;
+ (instancetype)loadFromNibWithFrame:(CGRect)frame;

@end
