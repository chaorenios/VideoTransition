//
//  LiveFullScreenViewController.swift
//  Layout
//
//  Created by 王世超 on 2018/10/24.
//  Copyright © 2018 CHAOREN. All rights reserved.
//

import UIKit

class LiveFullScreenViewController: UIViewController {

    var preferredInterfaceOrientation: UIInterfaceOrientation!
    var transitionView: LiveTransitionView!
    fileprivate let transition = LiveTransition()
    
    required init(_ view: LiveTransitionView) {
        super.init(nibName: nil, bundle: nil)
        transitionView = view
        initliaze()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // #warning("必须设置transitionView")
        initliaze()
    }
    
    fileprivate func initliaze() {
        transitioningDelegate = self
        view.backgroundColor = UIColor.clear
    }
    
    deinit {
        debugPrint("LiveFullScreenViewController - deinit")
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return preferredInterfaceOrientation
    }
}

extension LiveFullScreenViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionType = .present
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionType = .dismiss
        return transition
    }
}
