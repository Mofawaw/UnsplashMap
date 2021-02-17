//
//  UMLoadingVC.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 03.02.21.
//

import UIKit

protocol UMLoadingVCProtocol: UIViewController {
    
    var loadingVC: UMLoadingVC! { get set }
}


extension UMLoadingVCProtocol {
    
    func showLoadingView() {
        DispatchQueue.main.async {
            self.loadingVC = UMLoadingVC()
            self.loadingVC.modalPresentationStyle = .custom
            self.loadingVC.loadingWheel.startAnimating()
            
            self.present(self.loadingVC, animated: true)
        }
    }
    
    
    func dismissLoadingView(completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            self.loadingVC.dismiss(animated: true) {
                completion()
            }
        }
    }
}


class UMLoadingVC: UMViewOverlayVC {
    
    let loadingWheel = UIActivityIndicatorView(style: .large)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        transitioningDelegate = self
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UMColor.backgroundOpacity
        configureContainerView()
    }
    
    
    private func configureContainerView() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            containerView.widthAnchor.constraint(equalToConstant: 100),
            containerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(loadingWheel)
        
        loadingWheel.color = UMColor.blackToWhite
        loadingWheel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingWheel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            loadingWheel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
}
