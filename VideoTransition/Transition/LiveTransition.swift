//
//  LiveTransition.swift
//  Layout
//
//  Created by 王世超 on 2018/10/24.
//  Copyright © 2018 CHAOREN. All rights reserved.
//

import UIKit

enum LiveTransitionType {
    case present
    case dismiss
}

class LiveTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var transitionType = LiveTransitionType.present
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        switch transitionType {
        case .present:
            return 1.5
        case .dismiss:
            return 5.5
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case .present:
            debugPrint("Present:")
            guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
            guard let toVC = transitionContext.viewController(forKey: .to) else { return }
            // 将toVC的视图加入containerView
            toVC.view.frame = transitionContext.containerView.bounds
            transitionContext.containerView.addSubview(toVC.view)
            if let controller = toVC as? LiveFullScreenViewController {
                controller.transitionView.presentController(toVC, fromView: fromVC.view, toView: toVC.view, containerView: transitionContext.containerView) {
                    transitionContext.completeTransition(true)
                }
            }
        case .dismiss:
            debugPrint("Dismiss:")
            guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
            guard let toVC = transitionContext.viewController(forKey: .to) else { return }
            // 将toVC的视图插入到fromVC下面
            toVC.view.frame = transitionContext.containerView.bounds
            transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
            if let controller = fromVC as? LiveFullScreenViewController {
                controller.transitionView.dismissController(fromVC, fromView: fromVC.view, toView: toVC.view, containerView: transitionContext.containerView) {
                    transitionContext.completeTransition(true)
                }
            }
        }
    }
}
