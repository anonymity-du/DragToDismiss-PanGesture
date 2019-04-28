//
//  TestVideoView.swift
//  DragGesture-Swift
//
//  Created by 杜奎 on 2019/4/27.
//  Copyright © 2019 du. All rights reserved.
//

import UIKit
import AVKit

//此处视频播放仅仅用于展示手势效果，实际使用不可取
class TestVideoView: UIView {

    var outsideFrame = CGRect.zero
    var insideFrame = CGRect.zero
    var gesture: DragGestureHandler?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        self.addSubview(self.playBgView)
        self.addSubview(self.playView)
        self.addSubview(self.videoCoverView)
        
        self.gesture = DragGestureHandler.init(gestureView: self.playView, bgView: self.playBgView)
        self.gesture?.completeBlock = { [weak self] (finish) in
            if finish {
                self?.hide()
            }
        }
    }
    
    //MARK:- action
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.playBgView.alpha = 0
        self.playView.alpha = 0

        self.videoCoverView.frame = self.outsideFrame
        
        self.playView.frame = self.insideFrame
        self.playerLayer.frame = self.playView.bounds
        self.playView.layer.addSublayer(self.playerLayer)
        self.player.play()
        
        self.playBgView.isUserInteractionEnabled = false

        UIView.animate(withDuration: 0.3, animations: {
            self.playBgView.alpha = 1
            self.videoCoverView.frame = self.insideFrame
        }) { (finish) in
            self.playBgView.isUserInteractionEnabled = true
            self.playView.alpha = 1
            self.videoCoverView.alpha = 0
        }
    }
    
    func hide() {
        self.playBgView.isUserInteractionEnabled = false
        self.player.pause()
        self.playView.alpha = 0
        self.videoCoverView.alpha = 1
        self.videoCoverView.frame = self.playView.frame

        UIView.animate(withDuration: 0.3, animations: {
            self.playBgView.alpha = 0
            self.videoCoverView.frame = self.outsideFrame
        }) { (finish) in
            self.playBgView.isUserInteractionEnabled = true
            self.removeFromSuperview()
        }
    }
    
    @objc func tapAction() {
        self.hide()
    }
    
    //MARK:- setter & getter
    
    private lazy var player: AVPlayer = {
        let path = Bundle.main.path(forResource: "testVideo", ofType: ".MOV") ?? ""
        let filePath = "file://" + path
        let url = URL.init(string: filePath)
        let item = AVPlayerItem.init(url: url!)
        let player = AVPlayer.init(playerItem: item)
        return player
    }()
    
    private lazy var playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer.init(player: self.player)
        layer.videoGravity = AVLayerVideoGravity.resize
        return layer
    }()

    private lazy var playBgView: UIView = {
        let view = UIView.init(frame: self.bounds)
        view.backgroundColor = UIColor.black
        view.isUserInteractionEnabled = false
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapAction)))
        return view
    }()
    
    private lazy var playView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private(set) var videoCoverView: UIImageView = {
        let view = UIImageView.init()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

}
