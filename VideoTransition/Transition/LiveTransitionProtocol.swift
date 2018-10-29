//
//  LiveTransitionProtocol.swift
//  Layout
//
//  Created by CHAOREN on 2018/10/24.
//  Copyright © 2018 CHAOREN. All rights reserved.
//

import UIKit

enum LiveTransitionState {
    case beforPresent, afterPresent, beforDismiss, afterDismiss
}

protocol LiveTransitionViewProtocol {
    func presentController(_ controller: UIViewController, fromView: UIView, toView: UIView, containerView: UIView, completion: @escaping () -> ())
    func dismissController(_ controller: UIViewController, fromView: UIView, toView: UIView, containerView: UIView, completion: @escaping () -> ())
}
