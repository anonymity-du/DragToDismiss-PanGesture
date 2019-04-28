//
//  TestImageView.swift
//  DragGesture-Swift
//
//  Created by 杜奎 on 2019/4/27.
//  Copyright © 2019 du. All rights reserved.
//

import UIKit

class TestImageView: UIView {

    var outsideFrame = CGRect.zero
    var insideFrame = CGRect.zero
    var gesture: DragGestureHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.blackBgView)
        self.addSubview(self.imageView)
        
        self.gesture = DragGestureHandler.init(gestureView: self.imageView, bgView: self.blackBgView)
        self.gesture?.completeBlock = { [weak self] (finish) in
            if finish {
                self?.hide()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- action
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.blackBgView.alpha = 0
        self.imageView.frame = self.outsideFrame
        self.blackBgView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.frame = self.insideFrame
            self.blackBgView.alpha = 1
        }) { (finished) in
            self.blackBgView.isUserInteractionEnabled = true
        }
    }
    
    func hide() {
        self.blackBgView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.frame = self.outsideFrame
            self.blackBgView.alpha = 0
        }) { (finished) in
            self.blackBgView.isUserInteractionEnabled = true
            self.removeFromSuperview()
        }
    }
    
    @objc func tapAction() {
        self.hide()
    }
    
    //MARK:- setter & getter
    
    private lazy var blackBgView: UIView = {
        let view = UIView.init(frame: self.bounds)
        view.backgroundColor = UIColor.black
        view.isUserInteractionEnabled = false
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapAction)))
        return view
    }()
    
    private(set) var imageView: UIImageView = {
        let view = UIImageView.init()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
}
