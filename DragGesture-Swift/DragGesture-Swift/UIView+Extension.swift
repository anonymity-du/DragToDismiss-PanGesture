//
//  UIView+Extension.swift
//  ImitationOfTodayNews
//
//  Created by 杜奎 on 2017/5/24.
//  Copyright © 2017年 杜奎. All rights reserved.
//

import UIKit

extension UIView{
    var x : CGFloat {
        get {
            return frame.origin.x
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    var y : CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    var width : CGFloat {
        get {
            return frame.size.width
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    var height : CGFloat {
        get {
            return frame.size.height
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }
    
    var centerX : CGFloat {
        get {
            return center.x
        }
        set {
            var tempCenter : CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    var centerY : CGFloat {
        get {
            return center.y
        }
        set {
            var tempCenter : CGPoint = center
            tempCenter.y = newValue
            center = tempCenter
        }
    }
    var size : CGSize {
        get {
            return frame.size
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    var right : CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.x = newValue - frame.size.width
            frame = tempFrame
        }
    }
    
    var bottom : CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.y = newValue - frame.size.height
            frame = tempFrame
        }
    }
}
