//
//  PhotoTransitions.h
//  youbei
//
//  Created by 赵春阳 on 2018/12/10.
//  Copyright © 2018 赵春阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoTransitions : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithFromView:(UIView *)fromView isPresenting:(BOOL)present;

@end
