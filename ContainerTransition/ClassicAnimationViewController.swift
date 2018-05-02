//
//  ClassicAnimationViewController.swift
//  ContainerTransition
//
//  Created by Imanou on 03/05/2018.
//  Copyright © 2018 Imanou Petit. All rights reserved.
//

import UIKit

class ClassicAnimationViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let viewControllers: [UIViewController]
    var selectedViewController: UIViewController? {
        willSet {
            if let selectedViewController = newValue {
                transitionToChildViewController(selectedViewController)
            }
        }
        didSet {
            if let selectedViewController = selectedViewController, let index = viewControllers.index(of: selectedViewController) {
                segmentedControl.selectedSegmentIndex = index
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        let redControler = UIViewController()
        redControler.view.backgroundColor = .red
        let greenController = UIViewController()
        greenController.view.backgroundColor = .green
        let blueController = UIViewController()
        blueController.view.backgroundColor = .blue
        self.viewControllers = [redControler, greenController, blueController]
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        selectedViewController = viewControllers.first
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return self.selectedViewController
    }
    
    // MARK: - User interaction
    
    @IBAction func changeSelectedController(_ sender: UISegmentedControl) {
        selectedViewController = viewControllers[sender.selectedSegmentIndex]
    }
    
    // MARK: - Custom methods
    
    private func transitionToChildViewController(_ toViewController: UIViewController) {
        let toView = toViewController.view
        toView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toView?.frame = view.bounds
        
        guard let fromViewController = selectedViewController else {
            // If this is the initial presentation, add the new child with no animation.
            addChildViewController(toViewController)
            view.addSubview(toViewController.view)
            toViewController.didMove(toParentViewController: self)
            return
        }
        
        fromViewController.willMove(toParentViewController: nil)
        addChildViewController(toViewController)
        toViewController.view.alpha = 0
        self.segmentedControl.isUserInteractionEnabled = false
        
        let animations = { () -> Void in
            fromViewController.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            toViewController.view.alpha = 1
        }
        let completion = { (_: Bool) -> Void in
            fromViewController.removeFromParentViewController()
            fromViewController.view.transform = .identity
            toViewController.didMove(toParentViewController: self)
            self.segmentedControl.isUserInteractionEnabled = true
        }
        
        transition(from: fromViewController, to: toViewController, duration: 0.3, options: [], animations: animations, completion: completion)
    }
    
}
