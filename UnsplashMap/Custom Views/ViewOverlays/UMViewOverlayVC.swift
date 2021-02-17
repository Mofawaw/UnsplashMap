//
//  UMViewOverlayVC.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 03.02.21.
//

import UIKit
import ViewAnimator

class UMViewOverlayVC: UIViewController, UIViewControllerTransitioningDelegate {
    
    let containerView = UIView()
    

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        UMFeedback.rigid()
        return Presenter()
    }
     
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Dismisser()
    }
    
    
    private class Presenter: NSObject, UIViewControllerAnimatedTransitioning {
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.5
        }
            
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let overlayVC = transitionContext.viewController(forKey: .to) as? UMViewOverlayVC else { return }
            transitionContext.containerView.addSubview(overlayVC.view)
            
            overlayVC.view.animate(animations: [], duration: 0.3)
            
            let animation = AnimationType.vector(CGVector(dx: 0, dy: overlayVC.containerView.heightConstraint?.constant ?? 0))
            overlayVC.containerView.animate(animations: [animation], duration: 0.4) {
                transitionContext.completeTransition(true)
            }
        }
    }
    
    
    private class Dismisser: NSObject, UIViewControllerAnimatedTransitioning {
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.2
        }
            
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let overlayVC = transitionContext.viewController(forKey: .from) else { return }
            
            UIView.animate(withDuration: 0.2, animations: {
                overlayVC.view.alpha = 0
            }, completion: { _ in
                transitionContext.completeTransition(true)
                overlayVC.view.removeFromSuperview()
            })
        }
    }
}
