//
//  ScaleAnimatedTransition.swift
//  ContainerTransition
//
//  Created by Imanou on 03/05/2018.
//  Copyright © 2018 Imanou Petit. All rights reserved.
//

import UIKit

class ScaleAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        
        let animations = { () -> Void in
            fromViewController.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            toViewController.view.alpha = 1
        }
        let completion = { (_: Bool) -> Void in
            fromViewController.view.transform = .identity
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: animations, completion: completion)
    }
    
}
