//
//  AlertController.m
//  youbei
//
//  Created by 赵春阳 on 2018/12/5.
//  Copyright © 2018 赵春阳. All rights reserved.
//

#import "AlertController.h"

@implementation AlertController

+ (UIAlertController *)alertTitle:(NSString *)title message:(NSString *)message cancelText:(NSString *)cancelText doneText:(NSString *)doneText cancelBlock:(actionBlock)cancelBlock doneBlock:(actionBlock)doneBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:cancelBlock];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:doneText style:UIAlertActionStyleDefault handler:doneBlock];
    
    [alert addAction:cancelAction];
    [alert addAction:doneAction];
    return alert;
}

+ (UIAlertController *)alertTitle:(NSString *)title message:(NSString *)message doneText:(NSString *)doneText doneBlock:(actionBlock)doneBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:doneText style:UIAlertActionStyleDefault handler:doneBlock];
    
    [alert addAction:doneAction];
    return alert;
}


@end
