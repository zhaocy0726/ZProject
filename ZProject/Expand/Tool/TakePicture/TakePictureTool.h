//
//  YBTakePictureTool.h
//  youbei
//
//  Created by 赵春阳 on 2018/12/10.
//  Copyright © 2018 赵春阳. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface TakePictureTool : NSObject

+ (TakePictureTool *)sharedInstance;

- (void)takePicture:(UIImagePickerControllerSourceType)type success:(void(^)(UIImage *image))success;

@end

