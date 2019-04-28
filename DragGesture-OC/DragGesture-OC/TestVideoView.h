//
//  TestVideoView.h
//  DragGesture-OC
//
//  Created by 杜奎 on 2019/4/28.
//  Copyright © 2019 du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestVideoView : UIView

@property (nonatomic, assign) CGRect outsideFrame;
@property (nonatomic, assign) CGRect insideFrame;
@property (nonatomic, strong) UIImageView *videoCoverView;

- (void)show;

@end

