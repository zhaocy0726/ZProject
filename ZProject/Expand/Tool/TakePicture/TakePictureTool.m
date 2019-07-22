//
//  YBTakePictureTool.m
//  youbei
//
//  Created by 赵春阳 on 2018/12/10.
//  Copyright © 2018 赵春阳. All rights reserved.
//

#import "TakePictureTool.h"

@interface TakePictureTool () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *picker;
@property (copy,   nonatomic) void (^success)(UIImage *image);

@end

@implementation TakePictureTool

+ (TakePictureTool *)sharedInstance{
    static dispatch_once_t onceToken;
    static TakePictureTool *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TakePictureTool alloc] init];
    });
    return instance;
}

- (UIViewController *)currentTopViewController {
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)takePicture:(UIImagePickerControllerSourceType)type success:(void (^)(UIImage *))success {
    self.success = success;
    //判断设备支持
    if (type == UIImagePickerControllerSourceTypeCamera) {
        if (![UIImagePickerController isSourceTypeAvailable:type]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"该设备没有相机功能"
                                                               delegate:self cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
    } else if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
        if (![UIImagePickerController isSourceTypeAvailable:type]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"该设备不支持图片库"
                                                               delegate:self cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
    } else {
        if (![UIImagePickerController isSourceTypeAvailable:type]) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"该设备不支持照片库"
                                                               delegate:self cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    
    //判断隐私设置
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请到\"设置-隐私-相机\"选项中,允许该程序访问你的相机"
                                                           delegate:self cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    } else {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        //        _picker.allowsEditing = YES;
        _picker.sourceType = type;
        
        UIViewController *currentTopViewController = [self currentTopViewController];
        currentTopViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        [currentTopViewController presentViewController:_picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker == _picker) {
        UIImage * original_image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (original_image) {
            if (self.success) {
                self.success(original_image.fixOrientation);
            }
        }
    }
    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
