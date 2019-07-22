//
//  BackButton.m
//  youbei
//
//  Created by 赵春阳 on 2018/12/6.
//  Copyright © 2018 赵春阳. All rights reserved.
//

#import "BackButton.h"

@implementation BackButton

// 固定图片的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect titleFrame = self.titleLabel.frame;
    CGRect imageViewFrame = self.imageView.frame;
    
    imageViewFrame.origin = CGPointMake(5, (self.bounds.size.height - imageViewFrame.size.height) / 2);
    self.imageView.frame = imageViewFrame;
    
    titleFrame.origin = CGPointMake(CGRectGetMaxX(imageViewFrame) + 5, (self.bounds.size.height - titleFrame.size.height) / 2);
    self.titleLabel.frame = titleFrame;
}

@end
