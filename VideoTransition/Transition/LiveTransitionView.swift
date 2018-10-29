//
//  LiveTransitionView.swift
//  Layout
//
//  Created by 王世超 on 2018/10/24.
//  Copyright © 2018 CHAOREN. All rights reserved.
//

import UIKit
import SnapKit

/*
 在相应不旋转页面设定：
 override var shouldAutorotate: Bool {
    return true
 }
 
 override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
 }
 
 override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return .portrait
 }
 */

class LiveTransitionView: UIView {
    
    // original & target
    var originalViewController: UIViewController?
    var originalSuperView: UIView?
    
    var targetViewController: LiveFullScreenViewController?
    var targetSuperView: UIView?
    
    var originalSize = CGSize.zero
    var originalCenter = CGPoint.zero
    
    var targetSize = CGSize.zero
    var targetCenter = CGPoint.zero
    
    // transition
    var isFullScreen: Bool {
        return UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight
    }
    var currentInterfaceOrientation: UIInterfaceOrientation = .landscapeRight
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initliaze()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initliaze()
    }
    
    func initliaze() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toTransition))
        addGestureRecognizer(tap)
    }
    
    @objc func toTransition() {
        debugPrint("\(#function)- isFullScreen:\(isFullScreen)")
        if isFullScreen {
            targetViewController?.dismiss(animated: true, completion: {
                self.targetViewController = nil
                self.removeDeviceOrientationNotification()
            })
        } else {
            if targetViewController == nil {
                targetViewController = LiveFullScreenViewController(self)
            }
            // 进入全屏时，永远都是向右的
            currentInterfaceOrientation = .landscapeRight
            targetViewController?.preferredInterfaceOrientation = currentInterfaceOrientation
            originalViewController?.present(targetViewController!, animated: true, completion: {
                self.addDeviceOrientationNotification()
            })
        }
    }
    
    // MARK: - UIDevice Orientation
    func addDeviceOrientationNotification() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationNotification(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func deviceOrientationNotification(_ notification: Notification) {
        currentInterfaceOrientation = UIApplication.shared.statusBarOrientation
    }
    
    func removeDeviceOrientationNotification() {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: - Transition State Changed
    fileprivate func transitionStateChanged(_ state: LiveTransitionState) {
        switch state {
        case .beforPresent: transitionStateBeforPresent()
        case .afterPresent: transitionStateAfterPresent()
        case .beforDismiss: transitionStateBeforDismiss()
        case .afterDismiss: transitionStateAfterDismiss()
        }
    }
    
    fileprivate func transitionStateBeforPresent() {
        originalSuperView = superview
        originalSize = self.frame.size
        originalCenter = self.center
    }
    fileprivate func transitionStateAfterPresent() {
        targetSuperView = superview
    }
    fileprivate func transitionStateBeforDismiss() {}
    fileprivate func transitionStateAfterDismiss() {
        removeFromSuperview()
        originalSuperView?.addSubview(self)
        
        // 使用autolayout
//        self.bounds = CGRect(x: 0, y: 0, width: originalSize.width, height: originalSize.height)
//        self.center = originalCenter
        self.snp.remakeConstraints { (make) in
            make.center.equalTo(self.originalCenter)
            make.width.equalTo(self.originalSize.width)
            make.height.equalTo(self.originalSize.height)
        }
        self.transform = CGAffineTransform.identity
        originalSuperView?.setNeedsLayout()
        originalSuperView?.layoutIfNeeded()
    }
}

extension LiveTransitionView: LiveTransitionViewProtocol {

    func presentController(_ controller: UIViewController, fromView: UIView, toView: UIView, containerView: UIView, completion: @escaping () -> ()) {
        // 1.当前变换状态
        transitionStateChanged(.beforPresent)
        if let originalSV = originalSuperView {
            let angle = -CGFloat(Double.pi/2) // 旋转角度，向左旋转90度
            // 2.获取仿射转换的frame
            let convertFrame = originalSV.convert(self.frame, to: toView)
            // 3.获取仿射转换frame的center
            let convertCenter = CGPoint(x: convertFrame.midX, y: convertFrame.midY)
            // 4.从原view中移除并添加到toView
            self.removeFromSuperview()
            toView.addSubview(self)
            /*
             此时加入toView，为了造成“原始状态的假象”，也就是竖屏状态下的位置，需要通过旋转来实现
             */
            // 5.计算“原始状态”的width,height,center
            targetSize = CGSize(width: convertFrame.width, height: convertFrame.height)
            targetCenter = convertCenter
            // 6.旋转
            // 使用autolayout
            self.snp.remakeConstraints { (make) in
                make.center.equalTo(self.targetCenter)
                make.width.equalTo(self.targetSize.height)
                make.height.equalTo(self.targetSize.width)
            }
            // 使用frame
//            self.bounds = CGRect(x: 0, y: 0, width: targetSize.height, height: targetSize.width)
//            self.center = targetCenter
            self.transform = CGAffineTransform(rotationAngle: angle)
            // 7.刷新布局
            toView.setNeedsLayout()
            toView.layoutIfNeeded()
            // 8.假象已经出现，现在可以正常旋转回来, 加个动画，并使用全屏的size
            // 使用autolayout
            self.snp.updateConstraints { (make) in
                make.center.equalTo(toView.center)
                make.width.equalTo(toView.bounds.width)
                make.height.equalTo(toView.bounds.height)
            }
            UIView.animate(withDuration: 0.5, animations: {
                // 使用frame
//                self.bounds = CGRect(x: 0, y: 0, width: toView.bounds.width, height: toView.bounds.height)
//                self.center = toView.center
                self.transform = CGAffineTransform.identity
                toView.layoutIfNeeded()
            }) { (_) in
                self.transitionStateChanged(.afterPresent)
                completion()
            }
        }
    }
    
    func dismissController(_ controller: UIViewController, fromView: UIView, toView: UIView, containerView: UIView, completion: @escaping () -> ()) {
        // 1.当前变换状态
        transitionStateChanged(.beforDismiss)
        // 2.判断离开全屏时设备方向，来确定转的角度和位置
        var angle = -CGFloat(Double.pi/2) // 旋转角度，向右旋转90度
        var center = targetCenter
        switch currentInterfaceOrientation {
        case .landscapeLeft:
            angle = CGFloat(Double.pi/2)
            center = CGPoint(x: toView.frame.height - center.x, y: toView.frame.width - center.y)
        default:
            break
        }
        self.snp.updateConstraints { (make) in
            make.center.equalTo(center)
            make.width.equalTo(self.targetSize.height)
            make.height.equalTo(self.targetSize.width)
        }
        UIView.animate(withDuration: 0.5, animations: {
//            self.bounds = CGRect(x: 0, y: 0, width: self.targetSize.height, height: self.targetSize.width)
//            self.center = self.targetCenter
            self.transform = CGAffineTransform(rotationAngle: angle)
            fromView.layoutIfNeeded()
        }) { (_) in
            self.transitionStateChanged(.afterDismiss)
            completion()
        }
    }
}
