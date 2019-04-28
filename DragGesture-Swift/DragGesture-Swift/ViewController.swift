//
//  ViewController.swift
//  DragGesture-Swift
//
//  Created by 杜奎 on 2019/4/27.
//  Copyright © 2019 du. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var insideFrame = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //测试图为短图
        let path = Bundle.main.path(forResource: "testVideoCover", ofType: "jpg") ?? ""
        let testImage = UIImage.init(contentsOfFile: path)!
        let scale = testImage.size.height/testImage.size.width
        
        let insideWidth = self.view.width
        let insideHeight = insideWidth * scale
        self.insideFrame = CGRect.init(x: 0, y: (self.view.height - insideHeight) * 0.5, width: insideWidth, height: insideHeight)
        
        self.view.addSubview(self.videoView)
        self.videoView.size = CGSize.init(width: 250, height: 250 * scale)
        self.videoView.image = testImage
        self.videoView.centerX = self.view.width * 0.5
        self.videoView.y = 100
        
        self.videoView.addSubview(self.playIconView)
        self.playIconView.sizeToFit()
        self.playIconView.centerX = self.videoView.width * 0.5
        self.playIconView.centerY = self.videoView.height * 0.5
        
        self.view.addSubview(self.imageView)
        self.imageView.image = testImage
        self.imageView.size = self.videoView.size
        self.imageView.centerX = self.videoView.centerX
        self.imageView.y = self.videoView.bottom + 50
        // Do any additional setup after loading the view.
    }

    //MARK:- action
    
    @objc func imgShowAction() {
        let showView = TestImageView.init(frame: self.view.frame)
        showView.imageView.image = self.imageView.image
        showView.outsideFrame = self.imageView.frame
        showView.insideFrame = self.insideFrame
        showView.show()
    }
    
    @objc func videoShowAction() {
        let showView = TestVideoView.init(frame: self.view.frame)
        showView.videoCoverView.image = self.videoView.image
        showView.outsideFrame = self.videoView.frame
        showView.insideFrame = self.insideFrame
        showView.show()
    }
    
    //MARK:- setter & getter
    
    private lazy var videoView: UIImageView = {
        let view = UIImageView.init()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(videoShowAction)))
        return view
    }()

    private lazy var playIconView: UIImageView = {
        let view = UIImageView.init()
        view.image = UIImage.init(named: "ic_square_play")
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView.init()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(imgShowAction)))
        return view
    }()
}

