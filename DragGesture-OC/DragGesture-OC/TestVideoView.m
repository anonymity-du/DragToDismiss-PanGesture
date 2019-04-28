//
//  TestVideoView.m
//  DragGesture-OC
//
//  Created by 杜奎 on 2019/4/28.
//  Copyright © 2019 du. All rights reserved.
//

#import "TestVideoView.h"
#import <AVKit/AVKit.h>
#import "DragGestureHandler.h"

@interface TestVideoView ()

@property (nonatomic, strong) DragGestureHandler *gesture;
@property (nonatomic, strong) UIImageView *playBgView;
@property (nonatomic, strong) UIView      *playView;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playLayer;

@end

@implementation TestVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.playBgView];
    [self addSubview:self.playView];
    [self addSubview:self.videoCoverView];
    
    __weak typeof(self) weakSelf = self;
    self.gesture = [[DragGestureHandler alloc] initWithGestureView:self.playView bgView:self.playBgView];
    self.gesture.completeBlock = ^(BOOL finish) {
        if (finish) {
            [weakSelf hide];
        }
    };
}

#pragma mark - action

- (void)show {
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    self.playBgView.alpha = 0;
    self.playView.alpha = 0;
    
    self.videoCoverView.frame = self.outsideFrame;
    
    self.playView.frame = self.insideFrame;
    self.playLayer.frame = self.playView.bounds;
    [self.playView.layer addSublayer:self.playLayer];
    [self.player play];
    
    self.playBgView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.playBgView.alpha = 1;
        self.videoCoverView.frame = self.insideFrame;
    } completion:^(BOOL finished) {
        self.playBgView.userInteractionEnabled = YES;
        self.playView.alpha = 1;
        self.videoCoverView.alpha = 0;
    }];
}

- (void)hide {
    self.playBgView.userInteractionEnabled = NO;
    [self.player pause];
    self.playView.alpha = 0;
    self.videoCoverView.alpha = 1;
    self.videoCoverView.frame = self.playView.frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.playBgView.alpha = 0;
        self.videoCoverView.frame = self.outsideFrame;
    } completion:^(BOOL finished) {
        self.playBgView.userInteractionEnabled = YES;
        [self removeFromSuperview];
    }];
}

- (void)tagAction {
    [self hide];
}

#pragma mark - setter & getter

- (AVPlayer *)player {
    if (!_player) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"testVideo" ofType:@".MOV"];
        NSString *filePath = [NSString stringWithFormat:@"file://%@", path];
        NSURL *url = [[NSURL alloc] initWithString:filePath];
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
        _player = [[AVPlayer alloc] initWithPlayerItem:item];
    }
    return _player;
}

- (AVPlayerLayer *)playLayer {
    if (!_playLayer) {
        _playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playLayer.videoGravity = AVLayerVideoGravityResize;
    }
    return _playLayer;
}

- (UIImageView *)playBgView {
    if (!_playBgView) {
        _playBgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _playBgView.backgroundColor = UIColor.blackColor;
        _playBgView.userInteractionEnabled = NO;
        [_playBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagAction)]];
    }
    return _playBgView;
}

- (UIView *)playView {
    if (!_playView) {
        _playView = [[UIView alloc] init];
        _playView.backgroundColor = UIColor.clearColor;
        _playView.userInteractionEnabled = NO;
    }
    return _playView;
}

- (UIImageView *)videoCoverView {
    if (!_videoCoverView) {
        _videoCoverView = [[UIImageView alloc] init];
        _videoCoverView.contentMode = UIViewContentModeScaleAspectFill;
        _videoCoverView.clipsToBounds = YES;
    }
    return _videoCoverView;
}

@end
