//
//  LiveTransitionExtension.swift
//  Layout
//
//  Created by CHAOREN on 2018/10/25.
//  Copyright © 2018 CHAOREN. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    open override var shouldAutorotate : Bool {
        return selectedViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
    open override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return selectedViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }
    
}

extension UINavigationController {
    
    override open var shouldAutorotate : Bool {
        return topViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
    open override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return topViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }
}
