//
//  DragGestureHandler.h
//  DragGesture-OC
//
//  Created by 杜奎 on 2019/4/28.
//  Copyright © 2019 du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragGestureHandler : NSObject

//手势结束的回调
@property (nonatomic, copy) void (^completeBlock)(BOOL finish);
//有拖拽效果的拖拽回调
@property (nonatomic, copy) void (^dragBlock)(void);

- (instancetype)initWithGestureView:(UIView *)gestureView bgView:(UIView *)bgView;
    
@end

