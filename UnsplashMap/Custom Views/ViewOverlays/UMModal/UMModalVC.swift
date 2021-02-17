//
//  UMModalVC.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 04.02.21.
//

import UIKit

extension UIViewController {
    
    func showModalVC<T: UMModalCustomChildVC>(customChildVC: T, height: UMModalHeight) {
        DispatchQueue.main.async {
            let modalVC = UMModalVC(customChildVC: customChildVC, modalHeight: height)
            modalVC.modalPresentationStyle = .custom
            
            self.present(modalVC, animated: true)
        }
    }
}


class UMModalVC<T>: UMViewOverlayVC, UIGestureRecognizerDelegate where T: UMModalCustomChildVC {
    
    let dragIndicatorView = UMDragIndicatorView()
    
    let customChildVC: T
    var modalHeight: UMModalHeight
    
    var tapGesture: UITapGestureRecognizer!
    var dragGesture: UIPanGestureRecognizer!
    
    var currentInitialCenter = CGPoint.zero
    
    
    init(customChildVC: T, modalHeight: UMModalHeight) {
        self.customChildVC  = customChildVC
        self.modalHeight    = modalHeight
        
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate   = self
        customChildVC.delegate  = self
        
        tapGesture  = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTap(sender:)))
        dragGesture = UIPanGestureRecognizer(target: self, action: #selector(containerViewDrag(sender:)))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureContainerView()
    }
    
    
    private func configureView() {
        view.backgroundColor = UMColor.backgroundOpacity
        view.addGestureRecognizer(tapGesture)
        
        containerView.addGestureRecognizer(dragGesture)
        dragGesture.delegate = self
        dragGesture.isEnabled = modalHeight == .half
    }
    
    
    private func configureContainerView() {
        view.addSubview(containerView)
        
        containerView.backgroundColor = UMColor.whiteToDarkGray
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: modalHeight.height)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(customChildVC)
        containerView.addSubview(customChildVC.view)
        
        if modalHeight == .half {
            configureDragIndicatorView()
        }
        
        configureCustomChildVC()
    }
    
    
    private func configureDragIndicatorView() {
        containerView.addSubview(dragIndicatorView)
        
        NSLayoutConstraint.activate([
            dragIndicatorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            dragIndicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dragIndicatorView.widthAnchor.constraint(equalToConstant: dragIndicatorView.frame.size.width),
            dragIndicatorView.heightAnchor.constraint(equalToConstant: dragIndicatorView.frame.size.height)
        ])
    }
    
    
    private func removeDragIndicatorView() {
        containerView.willRemoveSubview(dragIndicatorView)
        dragIndicatorView.removeFromSuperview()
    }
    
    
    private func configureCustomChildVC() {
        NSLayoutConstraint.activate([
            customChildVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            customChildVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            customChildVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            customChildVC.view.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        
        customChildVC.view.translatesAutoresizingMaskIntoConstraints = false
        customChildVC.didMove(toParent: self)
    }
    
    
    @objc private func dismissAction() {
        self.dismiss(animated: true)
    }
    
    
    @objc private func backgroundViewTap(sender: UITapGestureRecognizer) {
        let point = sender.location(in: containerView)
        if !view.frame.contains(point) {
            dismissAction()
        }
    }
    
    
    @objc private func containerViewDrag(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began:
            currentInitialCenter = containerView.center
        case .changed:
            if translation.y >= 0 {
                containerView.center = CGPoint(x: currentInitialCenter.x, y: currentInitialCenter.y + translation.y)
            }
        case .ended:
            if translation.y > 100 {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    self.containerView.frame = self.containerView.frame.offsetBy(dx: 0, dy: self.containerView.frame.size.height - translation.y)
                }, completion: { _ in
                    self.dismissAction()
                })
            } else if translation.y >= 0 {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                    self.containerView.frame = self.containerView.frame.offsetBy(dx: 0, dy: -translation.y)
                }
            }
        default: break
        }
    }
}


extension UMModalVC: UMModalCustomChildVCDelegate {
    
    func changeModalHeight(to newHeight: UMModalHeight) {
        modalHeight = newHeight
        
        containerView.heightConstraint?.constant = newHeight.height
        containerView.setNeedsLayout()
        
        if newHeight == .full {
            dragGesture.isEnabled = false
            removeDragIndicatorView()
        } else {
            dragGesture.isEnabled = true
            configureDragIndicatorView()
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.view.layoutIfNeeded()
        }
    }
}


enum UMModalHeight {
    
    case half, full
    
    var height: CGFloat {
        switch self {
        case .half: return 480 + UMLayout.onlyOniPhoneXType(60)
        case .full: return UMLayout.screenHeight
        }
    }
    
    var closeButtonTopConstraint: CGFloat {
        switch self {
        case .half: return UMLayout.padding
        case .full: return UMLayout.padding + 10 + UMLayout.onlyOniPhoneXType(20)
        }
    }
}
