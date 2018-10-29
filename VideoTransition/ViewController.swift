//
//  ViewController.swift
//  VideoTransition
//
//  Created by CHAOREN on 2018/10/29.
//  Copyright © 2018 王世超. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var transitionView: LiveTransitionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitionView = LiveTransitionView(frame: .zero)
        transitionView.backgroundColor = UIColor.blue
        view.addSubview(transitionView)
        transitionView.snp.makeConstraints { (make) in
            make.top.equalTo(150)
            make.left.equalTo(50)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
        // * 设置原始的vc
        transitionView.originalViewController = self
    }
}

