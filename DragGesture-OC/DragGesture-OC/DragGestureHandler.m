//
//  DragGestureHandler.m
//  DragGesture-OC
//
//  Created by 杜奎 on 2019/4/28.
//  Copyright © 2019 du. All rights reserved.
//

#import "DragGestureHandler.h"
#import "UIView+Extension.h"

@interface DragGestureHandler ()

//是否开始拖拽
@property (nonatomic, assign) BOOL startDrag;
//是否需要对手势做出响应
@property (nonatomic, assign) BOOL noResponse;
//原始位置
@property (nonatomic, assign) CGRect originFrame;
//触摸点距离视图中心点距离
@property (nonatomic, assign) CGSize distanceToCenter;
//手势的对象视图
@property (nonatomic, weak) UIView *gestureView;
//背景视图
@property (nonatomic, weak) UIView *bgView;

@end

@implementation DragGestureHandler

- (instancetype)initWithGestureView:(UIView *)gestureView bgView:(UIView *)bgView {
    if (self = [super init]) {
        self.gestureView = gestureView;
        self.bgView = bgView;
        [self.bgView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)]];
    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer *)gesture {
    if (self.gestureView == nil || self.bgView == nil) {
        return;
    }
    
    CGPoint pointVelocity = [gesture velocityInView:self.bgView];
    CGPoint changePoint = [gesture translationInView:self.bgView];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始拖拽 begin dragging");
        self.startDrag = YES;
        self.noResponse = NO;
        self.originFrame = self.gestureView.frame;
        //拖拽点距离中心点距离
        CGPoint insidePoint = [gesture locationInView:self.gestureView];
        CGFloat distanceX = insidePoint.x - self.gestureView.width * 0.5;
        CGFloat distanceY = insidePoint.y - self.gestureView.height * 0.5;
        self.distanceToCenter = CGSizeMake(distanceX, distanceY);
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (self.startDrag == YES) {
            self.startDrag = false;
            if (changePoint.y < 0) {
                self.noResponse = YES;
            }else if (ABS(changePoint.x) > changePoint.y) {
                self.noResponse = YES;
            }
        }
        if (self.noResponse) {
            return;
        }
        if (self.dragBlock != nil) {
            self.dragBlock();
        }
        //背景的一半高度作为参照
        CGFloat halfHeight = self.bgView.height * 0.5;
        CGFloat halfWidth = self.bgView.width * 0.5;
        CGFloat surplus = changePoint.y > halfHeight ? halfHeight : changePoint.y;
        CGFloat scale = surplus/halfHeight;
        self.bgView.alpha = 0.1 + 0.9 * (1 - scale);
        
        //transform的scale
        CGFloat frameScale = (1 - 0.5 * scale);
        //移动之后的中心点（未做tranform变化）
        CGPoint afterCenter = CGPointMake(halfWidth + changePoint.x, halfHeight + changePoint.y);
        //做tranform变化后的中心点偏移
        CGFloat afterCenterOffsetY = self.distanceToCenter.height * (1 - frameScale);
        CGFloat afterCenterOffsetX = self.distanceToCenter.width * (1 - frameScale);
        self.gestureView.center = CGPointMake(afterCenter.x + afterCenterOffsetX, afterCenter.y + afterCenterOffsetY);
        self.gestureView.transform = CGAffineTransformMakeScale(frameScale, frameScale);
    }else if (gesture.state == UIGestureRecognizerStateEnded) {
        self.startDrag = NO;
        self.noResponse = NO;
        //如果放手的瞬时速度大于100或者偏移距离大于100，则走回调
        if (pointVelocity.y > 100 || changePoint.y > 80) {
            if (self.completeBlock != nil) {
                self.completeBlock(true);
            }
        }else {
            [UIView animateWithDuration:0.3 animations:^{
                self.gestureView.transform = CGAffineTransformIdentity;
                self.gestureView.frame = self.originFrame;
                self.bgView.alpha = 1;
            }];
            if (self.completeBlock != nil) {
                self.completeBlock(false);
            }
        }
    }
}

@end
