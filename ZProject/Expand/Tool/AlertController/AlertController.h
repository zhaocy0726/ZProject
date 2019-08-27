//
//  AlertController.h
//  youbei
//
//  Created by 赵春阳 on 2018/12/5.
//  Copyright © 2018 赵春阳. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^actionBlock)(UIAlertAction *action);

@interface AlertController : NSObject

+ (UIAlertController *)alertTitle:(NSString *)title message:(NSString *)message cancelText:(NSString *)cancelText doneText:(NSString *)doneText cancelBlock:(actionBlock)cancelBlock doneBlock:(actionBlock)doneBlock;

+ (UIAlertController *)alertTitle:(NSString *)title message:(NSString *)message doneText:(NSString *)doneText doneBlock:(actionBlock)doneBlock;

@end

