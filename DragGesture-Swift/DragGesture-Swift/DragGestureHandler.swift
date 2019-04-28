//
//  DragGestureHandler.swift
//  DragGesture-Swift
//
//  Created by 杜奎 on 2019/4/27.
//  Copyright © 2019 du. All rights reserved.
//

import UIKit

class DragGestureHandler: NSObject {
    //是否开始拖拽
    private var startDrag = false
    //是否需要对手势做出响应
    private var noResponse = false
    //原始位置
    private var originFrame = CGRect.zero
    //触摸点距离视图中心点距离
    private var distanceToCenter = CGSize.zero
    
    
    //手势的对象视图
    weak var gestureView: UIView?
    //背景视图
    weak var bgView: UIView?
    //手势结束的回调
    var completeBlock: ((_ finish: Bool)->())?
    //有拖拽效果的拖拽回调
    var dragBlock: (()->())?
    
    convenience init(gestureView: UIView, bgView: UIView) {
        self.init()
        
        self.gestureView = gestureView
        self.bgView = bgView
        bgView.addGestureRecognizer(self.panGesture)
    }
    
    override init() {
        super.init()
    }
    
    @objc private func panAction(gesture: UIPanGestureRecognizer) {
        guard let operateView = self.gestureView,let bgView = self.bgView else {
            return
        }
        let pointVelocity = gesture.velocity(in: bgView)
        let changePoint = gesture.translation(in: bgView)
        
        switch (gesture.state) {
        case .began:// 识别器已经接收识别为此手势(状态)的触摸(Began)
            print("开始拖拽 begin dragging")
            self.startDrag = true
            self.noResponse = false
            self.originFrame = operateView.frame
            //拖拽点距离中心点距离
            let insidePoint = gesture.location(in: operateView)
            let distanceX = insidePoint.x - operateView.width * 0.5
            let distanceY = insidePoint.y - operateView.height * 0.5
            self.distanceToCenter = CGSize.init(width: distanceX, height: distanceY)
        case .changed:// 识别器已经接收到触摸，并且识别为手势改变(Changed)
            //只有第一象限和第四象限靠近Y柱的生效
            if self.startDrag == true {
                self.startDrag = false
                if changePoint.y < 0 {
                    self.noResponse = true
                }else if abs(changePoint.x) > changePoint.y {
                    self.noResponse = true
                }
            }

            if self.noResponse {
                return
            }
            if self.dragBlock != nil {
                self.dragBlock!()
            }
            
            //背景的一半高度作为参照
            let halfHeight = bgView.height * 0.5
            let halfWidth = bgView.width * 0.5
            let surplus = changePoint.y > halfHeight ? halfHeight : changePoint.y
            let scale = surplus/halfHeight
            bgView.alpha = 0.1 + 0.9 * (1 - scale)

            //transform的scale
            let frameScale = (1 - 0.5 * scale)
            //移动之后的中心点（未做tranform变化）
            let afterCenter = CGPoint.init(x: halfWidth + changePoint.x, y: halfHeight + changePoint.y)
            //做tranform变化后的中心点偏移
            let afterCenterOffsetY = self.distanceToCenter.height * (1 - frameScale)
            let afterCenterOffsetX = self.distanceToCenter.width * (1 - frameScale)
            //实际改变operateView的中心点和transform
            operateView.center = CGPoint.init(x: afterCenter.x + afterCenterOffsetX, y: afterCenter.y + afterCenterOffsetY)
            operateView.transform = CGAffineTransform.init(scaleX: frameScale, y: frameScale)
        case .ended:// 识别器已经接收到触摸，并且识别为手势结束(Ended)
            print("结束拖拽 end dragging")

            self.startDrag = false
            self.noResponse = false
            //如果放手的瞬时速度大于100或者偏移距离大于100，则走回调
            if pointVelocity.y > 100 || changePoint.y > 80 {
                if self.completeBlock != nil {
                    self.completeBlock!(true)
                }
            }else {
                UIView.animate(withDuration: 0.3) {
                    operateView.transform = CGAffineTransform.identity
                    operateView.frame = self.originFrame
                    bgView.alpha = 1
                }
                if self.completeBlock != nil {
                    self.completeBlock!(false)
                }
            }
        default:
            break
        }
    }
    
    //MARK:- setter & getter
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(gesture:)))
        return gesture
    }()
}
