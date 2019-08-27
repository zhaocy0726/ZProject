//
//  PlayerController.h
//  youbei
//
//  Created by 赵春阳 on 2019/2/15.
//  Copyright © 2019 赵春阳. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface PlayerController : MPMoviePlayerController

@property (nonatomic, copy) void(^dimissCompleteBlock)(void);
@property (copy, nonatomic) void (^hiddentStatusBarBlock)(BOOL hidden); // 隐藏状态栏
@property (copy, nonatomic) void (^updateCollectBlock)(BOOL collect); // 修改收藏状态
@property (nonatomic, assign) CGRect frame;
@property (assign, nonatomic) BOOL collect; // 收藏状态

- (instancetype)initWithFrame:(CGRect)frame;
- (void)showInWindow;
- (void)dismiss;

@end
