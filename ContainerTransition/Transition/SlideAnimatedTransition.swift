//
//  PrivateAnimatedTransition.swift
//  ContainerTransition
//
//  Created by Imanou on 02/05/2018.
//  Copyright © 2018 Imanou Petit. All rights reserved.
//

import UIKit

/**
 Instances of this private class perform the default transition animation which is to slide child views horizontally.
 - note: The class only supports UIViewControllerAnimatedTransitioning at this point. Not UIViewControllerInteractiveTransitioning.
 */
class SlideAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let damping: CGFloat = 0.8
        let initialSpringVelocity: CGFloat = 0.5
        let childViewPadding: CGFloat = 16
        
        // Slide views horizontally, with a bit of space between, while fading out and in.
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        
        // When sliding the views horizontally in and out, figure out whether we are going left or right.
        let goingRight = transitionContext.initialFrame(for: toViewController).origin.x < transitionContext.finalFrame(for: toViewController).origin.x
        let travelDistance = transitionContext.containerView.bounds.width + childViewPadding
        let travel = CGAffineTransform(translationX: goingRight ? travelDistance : -travelDistance, y: 0)
        
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        toViewController.view.transform = travel.inverted()
        
        let animations = { () -> Void in
            fromViewController.view.transform = travel
            fromViewController.view.alpha = 0
            toViewController.view.transform = .identity
            toViewController.view.alpha = 1
        }
        let completion = { (_: Bool) -> Void in
            fromViewController.view.transform = .identity
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: [], animations: animations, completion: completion)
    }
    
}
