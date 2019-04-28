//
//  ViewController.m
//  DragGesture-OC
//
//  Created by 杜奎 on 2019/4/28.
//  Copyright © 2019 du. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"
#import "TestImageView.h"
#import "TestVideoView.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *videoView;
@property (nonatomic, strong) UIImageView *playIconView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect       insideFrame;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //测试图为短图
    NSString *path = [[NSBundle mainBundle] pathForResource:@"testVideoCover" ofType:@"jpg"];
    UIImage *testImage = [[UIImage alloc] initWithContentsOfFile:path];
    CGFloat scale = testImage.size.height/testImage.size.width;
    
    CGFloat insideWidth = self.view.width;
    CGFloat insideHeight = insideWidth * scale;
    self.insideFrame = CGRectMake(0, (self.view.height - insideHeight) * 0.5, insideWidth, insideHeight);

    [self.view addSubview:self.videoView];
    self.videoView.size = CGSizeMake(250, 250 * scale);
    self.videoView.image = testImage;
    self.videoView.centerX = self.view.width * 0.5;
    self.videoView.y = 100;
    
    [self.videoView addSubview:self.playIconView];
    [self.playIconView sizeToFit];
    self.playIconView.centerX = self.videoView.width * 0.5;
    self.playIconView.centerY = self.videoView.height * 0.5;
    
    [self.view addSubview:self.imageView];
    self.imageView.image = testImage;
    self.imageView.size = self.videoView.size;
    self.imageView.centerX = self.videoView.centerX;
    self.imageView.y = self.videoView.bottom + 50;

    // Do any additional setup after loading the view.
}

#pragma mark - action

- (void)imgShowAction {
    TestImageView *showView = [[TestImageView alloc] initWithFrame:self.view.frame];
    showView.imageView.image = self.imageView.image;
    showView.outsideFrame = self.imageView.frame;
    showView.insideFrame = self.insideFrame;
    [showView show];
}

- (void)videoShowAction {
    TestVideoView *showView = [[TestVideoView alloc] initWithFrame:self.view.frame];
    showView.videoCoverView.image = self.videoView.image;
    showView.outsideFrame = self.videoView.frame;
    showView.insideFrame = self.insideFrame;
    [showView show];
}


#pragma mark - setter & getter

- (UIImageView *)videoView {
    if (!_videoView) {
        _videoView = [[UIImageView alloc] init];
        _videoView.userInteractionEnabled = YES;
        [_videoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoShowAction)]];
    }
    return _videoView;
}

- (UIImageView *)playIconView {
    if (!_playIconView) {
        _playIconView = [[UIImageView alloc] init];
        _playIconView.image = [UIImage imageNamed:@"ic_square_play"];
    }
    return _playIconView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgShowAction)]];
    }
    return _imageView;
}

@end
