//
//  AnimationUtility.swift
//  OstomyScan
//
//  Created by Lucas Cauthen on 1/16/17.
//  Copyright © 2017 OstomyTech. All rights reserved.
//
import UIKit

class AnimationUtility {
    static func fadeIn(_ view:UIView, duration:TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 1.0
        })
    }
    static func fadeOut(_ view:UIView, duration:TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 0.0
        })
    }
    static func jitter(_ views:Array<UIView>) {
        for view in views {
            jitter(view)
        }
    }
    static func jitter(_ view:UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: view.center.x - 5.0, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint.init(x: view.center.x + 5.0, y: view.center.y))
        view.layer.add(animation, forKey: "position")
    }
}
