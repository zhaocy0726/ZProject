//
//  YNPageTableView.m
//  YNPageViewController
//
//  Created by ZYN on 2018/7/14.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNPageTableView.h"

@interface YNPageTableView () <UIGestureRecognizerDelegate>

@end

@implementation YNPageTableView
// 支持多个手势一起触发方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}



@end
