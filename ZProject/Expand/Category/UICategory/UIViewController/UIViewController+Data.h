//
//  UIViewController+Data.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewController (Data)

@property (strong, nonatomic) id data;

- (void)dataDidChange;
- (void)dataWillChange;

@end
