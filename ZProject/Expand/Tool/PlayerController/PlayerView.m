//
//  PlayerView.m
//  youbei
//
//  Created by 赵春阳 on 2019/2/15.
//  Copyright © 2019 赵春阳. All rights reserved.
//

#import "PlayerView.h"

static const CGFloat kVideoControlBottomBarHeight = 49.0;
static const CGFloat kVideoControlAnimationTimeInterval = 0.3;
static const CGFloat kVideoControlTimeLabelFontSize = 10.0;
static const CGFloat kVideoControlBarAutoFadeOutTimeInterval = 5.0;

@interface PlayerView ()

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *shrinkScreenButton;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIButton *closeButton;
@property (strong, nonatomic) UIButton *collectButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) BOOL isBarShowing;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation PlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topBar];
        [self addSubview:self.closeButton];
        [self addSubview:self.bottomBar];
        [self.bottomBar addSubview:self.playButton];
        [self.bottomBar addSubview:self.pauseButton];
        self.pauseButton.hidden = YES;
        [self.bottomBar addSubview:self.fullScreenButton];
        [self.bottomBar addSubview:self.shrinkScreenButton];
        self.shrinkScreenButton.hidden = YES;
        [self.bottomBar addSubview:self.progressSlider];
        [self.bottomBar addSubview:self.timeLabel];
        [self.bottomBar addSubview:self.collectButton];
        [self addSubview:self.indicatorView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topBar.frame = CGRectMake(CGRectGetMinX(self.bounds),
                                   CGRectGetMinY(self.bounds),
                                   CGRectGetWidth(self.bounds),
                                   kNavigationBar_HEIGHT);
    
    self.closeButton.frame = CGRectMake(_isFullscreenMode ? kStatusBar_Height : 0,
                                        CGRectGetHeight(self.topBar.bounds) - CGRectGetHeight(self.closeButton.bounds),
                                        CGRectGetWidth(self.closeButton.bounds),
                                        CGRectGetHeight(self.closeButton.bounds));
    
    self.bottomBar.frame = CGRectMake(CGRectGetMinX(self.bounds),
                                      CGRectGetHeight(self.bounds) - kVideoControlBottomBarHeight,
                                      CGRectGetWidth(self.bounds),
                                      kVideoControlBottomBarHeight);
    
    self.playButton.frame = CGRectMake(_isFullscreenMode ? CGRectGetMinX(self.bottomBar.bounds) + kStatusBar_Height : CGRectGetMinX(self.bottomBar.bounds),
                                       CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.playButton.bounds)/2,
                                       CGRectGetWidth(self.playButton.bounds),
                                       CGRectGetHeight(self.playButton.bounds));
    
    self.pauseButton.frame = self.playButton.frame;
    
    self.fullScreenButton.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreenButton.bounds),
                                             CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.fullScreenButton.bounds)/2,
                                             CGRectGetWidth(self.fullScreenButton.bounds),
                                             CGRectGetHeight(self.fullScreenButton.bounds));
    
    self.shrinkScreenButton.frame = self.fullScreenButton.frame;
    
    self.collectButton.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreenButton.bounds) - CGRectGetWidth(self.collectButton.bounds),
                                          CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.collectButton.bounds)/2,
                                          CGRectGetWidth(self.collectButton.bounds),
                                          CGRectGetHeight(self.collectButton.bounds));
    
    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(self.playButton.frame),
                                           CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.progressSlider.bounds)/2,
                                           CGRectGetMinX(self.fullScreenButton.frame) - CGRectGetMaxX(self.playButton.frame) - CGRectGetWidth(self.collectButton.bounds),
                                           CGRectGetHeight(self.progressSlider.bounds));
    
    self.timeLabel.frame = CGRectMake(CGRectGetMidX(self.progressSlider.frame),
                                      CGRectGetHeight(self.bottomBar.bounds) - CGRectGetHeight(self.timeLabel.bounds) - 2.0,
                                      CGRectGetWidth(self.progressSlider.bounds)/2,
                                      CGRectGetHeight(self.timeLabel.bounds));
    
    self.indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.isBarShowing = YES;
}

- (void)animateHide
{
    if (!self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:kVideoControlAnimationTimeInterval animations:^{
        if (self.isFullscreenMode) {
            self.closeButton.alpha = 0.0;
        }
        self.topBar.alpha = 0.0;
        self.bottomBar.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = NO;
    }];
}

- (void)animateShow
{
    if (self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:kVideoControlAnimationTimeInterval animations:^{
        self.closeButton.alpha = 1.0;
        self.topBar.alpha = 1.0;
        self.bottomBar.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = YES;
        [self autoFadeOutControlBar];
    }];
}

- (void)autoFadeOutControlBar
{
    if (!self.isBarShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeInterval];
}

- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}

- (void)onTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isBarShowing) {
            [self animateHide];
        } else {
            [self animateShow];
        }
    }
}

- (void)setIsFullscreenMode:(BOOL)isFullscreenMode
{
    _isFullscreenMode = isFullscreenMode;
    [self layoutSubviews];
}

- (void)setIsCollect:(BOOL)isCollect
{
    _isCollect = isCollect;
    [self.collectButton setImage:_isCollect ? ImageFromName(@"icon_video_collect_1") : ImageFromName(@"icon_video_collect_0") forState:UIControlStateNormal];
}

#pragma mark - Property

- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.backgroundColor = [UIColor clearColor];
    }
    return _topBar;
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _bottomBar;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:ImageFromName(@"icon_video_play") forState:UIControlStateNormal];
        _playButton.bounds = CGRectMake(0, 0, 40, 40);
    }
    return _playButton;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:ImageFromName(@"icon_video_pause") forState:UIControlStateNormal];
        _pauseButton.bounds = CGRectMake(0, 0, 40, 40);
    }
    return _pauseButton;
}

- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:ImageFromName(@"icon_video_zoom_in") forState:UIControlStateNormal];
        _fullScreenButton.bounds = CGRectMake(0, 0, 40, 40);
    }
    return _fullScreenButton;
}

- (UIButton *)shrinkScreenButton
{
    if (!_shrinkScreenButton) {
        _shrinkScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shrinkScreenButton setImage:ImageFromName(@"icon_video_zoom_out") forState:UIControlStateNormal];
        _shrinkScreenButton.bounds = CGRectMake(0, 0, 40, 40);
    }
    return _shrinkScreenButton;
}

- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
//        [_progressSlider setThumbImage:ImageFromName(@"player_point") forState:UIControlStateNormal];
        _progressSlider.minimumTrackTintColor = UIColor.redColor; // 已播放
        _progressSlider.maximumTrackTintColor = UIColor.greenColor; // 未播放
        _progressSlider.thumbTintColor = UIColor.greenColor; // 滑块
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:ImageFromName(@"icon_arrow_left_white_wide") forState:UIControlStateNormal];
        _closeButton.bounds = CGRectMake(0, 0, 40, 40);
    }
    return _closeButton;
}

- (UIButton *)collectButton
{
    if (_collectButton == nil) {
        _collectButton = [UIButton new];
        [_collectButton setImage:ImageFromName(@"icon_video_collect_0") forState:UIControlStateNormal];
        _collectButton.bounds = CGRectMake(0, 0, 40, 40);
    }
    return _collectButton;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:kVideoControlTimeLabelFontSize];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlTimeLabelFontSize);
    }
    return _timeLabel;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_indicatorView stopAnimating];
    }
    return _indicatorView;
}

@end
