//
//  PrivateTransitionContext.swift
//  ContainerTransition
//
//  Created by Imanou on 02/05/2018.
//  Copyright © 2018 Imanou Petit. All rights reserved.
//

import UIKit

/**
 A private UIViewControllerContextTransitioning class to be provided transitioning delegates.
 - discussion: Because we are a custom UIViewController class, with our own containment implementation, we have to provide an object conforming to the UIViewControllerContextTransitioning protocol. The system view controllers use one provided by the framework, which we cannot configure, let alone create. This class will be used even if the developer provides their own transitioning objects.
 - note: The only methods that will be called on objects of this class are the ones defined in the UIViewControllerContextTransitioning protocol. The rest is our own private implementation.
 */
class TransitionContext: NSObject, UIViewControllerContextTransitioning {

    /// A block of code we can set to execute after having received the completeTransition: message.
    var completionBlock: ((Bool) -> Void)?
    let privateViewControllers: [UITransitionContextViewControllerKey: UIViewController]
    
    // protocol required properties
    var presentationStyle: UIModalPresentationStyle
    let containerView: UIView
    let privateDisappearingFromRect: CGRect
    let privateAppearingFromRect: CGRect
    let privateDisappearingToRect: CGRect
    let privateAppearingToRect: CGRect
    let isAnimated = true
    let isInteractive = false
    let transitionWasCancelled = false
    let targetTransform = CGAffineTransform.identity

    init(withFromViewController fromViewController: UIViewController, toViewController: UIViewController, goingRight: Bool) {
        assert(fromViewController.isViewLoaded && fromViewController.view.superview != nil, "The fromViewController view must reside in the container view upon initializing the transition context.")

        self.presentationStyle = .custom
        self.containerView = fromViewController.view.superview!
        self.privateViewControllers = [UITransitionContextViewControllerKey.from: fromViewController, UITransitionContextViewControllerKey.to: toViewController]
        
        // Set the view frame properties which make sense in our specialized ContainerViewController context. Views appear from and disappear to the sides, corresponding to where the icon buttons are positioned. So tapping a button to the right of the currently selected, makes the view disappear to the left and the new view appear from the right. The animator object can choose to use this to determine whether the transition should be going left to right, or right to left, for example.
        let travelDistance = (goingRight ? -self.containerView.bounds.size.width : self.containerView.bounds.size.width)
        self.privateDisappearingFromRect = self.containerView.bounds
        self.privateAppearingToRect = self.containerView.bounds
        self.privateDisappearingToRect = self.containerView.bounds.offsetBy(dx: travelDistance, dy: 0)
        self.privateAppearingFromRect = self.containerView.bounds.offsetBy(dx: -travelDistance, dy: 0)

        super.init()
    }
    
    func initialFrame(for vc: UIViewController) -> CGRect {
        if vc === viewController(forKey: .from) {
            return privateDisappearingFromRect
        } else {
            return privateAppearingFromRect
        }
    }

    func finalFrame(for vc: UIViewController) -> CGRect {
        if vc === viewController(forKey: .from) {
            return privateDisappearingToRect
        } else {
            return privateAppearingToRect
        }
    }
    
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return privateViewControllers[key]
    }
    
    func completeTransition(_ didComplete: Bool) {
        completionBlock?(didComplete)
    }
    
    func updateInteractiveTransition(_ percentComplete: CGFloat) {}
    func finishInteractiveTransition() {}
    func cancelInteractiveTransition() {}
    func pauseInteractiveTransition() {}
    func view(forKey key: UITransitionContextViewKey) -> UIView? { return nil }

}
