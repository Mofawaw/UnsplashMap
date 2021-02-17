//
//  PhotoModalVC.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 04.02.21.
//

import UIKit

class PhotoModalVC: UMModalCustomChildVC {
    
    let photo: Photo
    
    let topButton = UMCircleButton(size: .small, appearance: .light, symbol: SFSymbol.xmark)
    var photoInfoVC: PhotoInfoVC!
    var photoUnsplashWebVC: PhotoUnsplashWebVC!

    
    init(photo: Photo) {
        self.photo = photo
        
        super.init(nibName: nil, bundle: nil)
        self.photoInfoVC = PhotoInfoVC(parentVC: self)
        self.photoUnsplashWebVC = PhotoUnsplashWebVC(urlString: photo.unsplashURL)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    private func configure() {
        view.addSubview(topButton)
        
        configureTopButton()
        configureChildVC(photoInfoVC)
    }
    
    
    private func configureTopButton() {
        NSLayoutConstraint.activate([
            topButton.topAnchor.constraint(equalTo: view.topAnchor, constant: UMModalHeight.half.closeButtonTopConstraint),
            topButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UMLayout.padding),
            topButton.widthAnchor.constraint(equalToConstant: topButton.frame.size.width),
            topButton.heightAnchor.constraint(equalToConstant: topButton.frame.size.height)
        ])
        
        topButton.addTarget(self, action: #selector(topButtonAction), for: .touchUpInside)
    }
    
    
    @objc private func topButtonAction() {
        if delegate?.modalHeight == .half {
            self.dismiss(animated: true)
        } else {
            toPhotoInfoVC()
        }
    }
    
    
    func toPhotoUnsplashVC() {
        delegate?.changeModalHeight(to: .full)
        view.topPadding?.constant = UMModalHeight.full.closeButtonTopConstraint
        removeChildVC(photoInfoVC)
        configureChildVC(photoUnsplashWebVC)
        topButton.setImage(SFSymbol.arrowDown, for: .normal)
    }
    
    
    func toPhotoInfoVC() {
        delegate?.changeModalHeight(to: .half)
        view.topPadding?.constant = UMModalHeight.half.closeButtonTopConstraint
        removeChildVC(photoUnsplashWebVC)
        configureChildVC(photoInfoVC)
        topButton.setImage(SFSymbol.xmark, for: .normal)
    }
    
    
    private func configureChildVC(_ childVC: UIViewController) {
        addChild(childVC)
        view.addSubview(childVC.view)
        
        NSLayoutConstraint.activate([
            childVC.view.topAnchor.constraint(equalTo: topButton.bottomAnchor, constant: UMLayout.padding),
            childVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        childVC.didMove(toParent: self)
    }
    
    
    private func removeChildVC(_ childVC: UIViewController) {
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }
}
