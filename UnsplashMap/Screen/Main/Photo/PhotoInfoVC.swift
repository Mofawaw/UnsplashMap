//
//  PhotoInfoVC.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 05.02.21.
//

import UIKit
import GoogleMaps

class PhotoInfoVC: UIViewController {
    
    let topAreaStackView = UIStackView()
    let titleLabel = UMBodyLabel(font: .h3)
    let imageView = PhotoImageView()
    
    let buttonStackView = UIStackView()
    let unsplashButton  = UMCircleButton(size: .medium, appearance: .light, symbol: SFSymbol.globe)
    let locationButton  = UMCircleButton(size: .large, appearance: .dark, symbol: SFSymbol.location)
    let deleteButton    = UMCircleButton(size: .medium, appearance: .light, symbol: SFSymbol.trash)
    
    let locationLabel   = UMBodyLabel(font: .h2, alignment: .center)
    let usernameLabel   = UMBodyLabel(font: .body, alignment: .center)
    
    weak var parentVC: PhotoModalVC!
    
    
    init(parentVC: PhotoModalVC) {
        self.parentVC = parentVC
        
        super.init(nibName: nil, bundle: nil)
        configureData()
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureData() {
        titleLabel.text = parentVC.photo.title ?? "No description"
        locationLabel.text = parentVC.photo.location.name
        usernameLabel.text = parentVC.photo.username ?? "No username"
        
        imageView.downloadImage(photo: parentVC.photo, size: .regular)
    }
    
    
    private func configure() {
        view.addSubview(topAreaStackView)
        view.addSubview(buttonStackView)
        view.addSubview(locationLabel)
        view.addSubview(usernameLabel)
        
        configureTopArea()
        configureButtons()
        configureBottomArea()
        configureButtonActions()
    }
    
    
    private func configureTopArea() {
        titleLabel.numberOfLines = 6
        
        topAreaStackView.addArrangedSubview(titleLabel)
        topAreaStackView.addArrangedSubview(imageView)
        
        topAreaStackView.axis         = .horizontal
        topAreaStackView.distribution = .fillEqually
        topAreaStackView.spacing      = 24
        
        let photoImageSize: CGFloat = (UMLayout.screenWidth-UMLayout.padding) / 2 - topAreaStackView.spacing
        
        NSLayoutConstraint.activate([
            topAreaStackView.topAnchor.constraint(equalTo: view.topAnchor),
            topAreaStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UMLayout.padding),
            topAreaStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UMLayout.padding),
            topAreaStackView.heightAnchor.constraint(equalToConstant: photoImageSize)
        ])
        
        topAreaStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func configureButtons() {
        buttonStackView.addArrangedSubview(unsplashButton)
        buttonStackView.addArrangedSubview(locationButton)
        buttonStackView.addArrangedSubview(deleteButton)
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 32
        buttonStackView.alignment = .center
        
        NSLayoutConstraint.activate([
            unsplashButton.heightAnchor.constraint(equalToConstant: unsplashButton.frame.size.height),
            unsplashButton.widthAnchor.constraint(equalToConstant: unsplashButton.frame.size.width),
            
            locationButton.heightAnchor.constraint(equalToConstant: locationButton.frame.size.height),
            locationButton.widthAnchor.constraint(equalToConstant: locationButton.frame.size.width),
            
            deleteButton.heightAnchor.constraint(equalToConstant: deleteButton.frame.size.height),
            deleteButton.widthAnchor.constraint(equalToConstant: deleteButton.frame.size.width),
            
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: topAreaStackView.bottomAnchor, constant: 40),
            buttonStackView.heightAnchor.constraint(equalToConstant: locationButton.frame.size.height),
        ])
                
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func configureBottomArea() {
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            locationLabel.heightAnchor.constraint(equalToConstant: 50),

            usernameLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    private func configureButtonActions() {
        unsplashButton.addTarget(self, action: #selector(unsplashButtonAction), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(locationButtonAction), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
    }
    
    
    @objc private func unsplashButtonAction() {
        parentVC.toPhotoUnsplashVC()
    }
    
    
    @objc private func locationButtonAction() {
        if let mainTabBarC = parentVC.presentingViewController as? MainTabBarC {
            mainTabBarC.selectedIndex = 1
            
            for tabVC in mainTabBarC.viewControllers! {
                if let mapVC = tabVC as? MapVC {
                    mapVC.cameraToLocation(parentVC.photo.cLLocation)
                }
            }
        }
        parentVC.dismiss(animated: true)
    }
    
    
    @objc private func deleteButtonAction() {
        self.showPopupVC(title: "Delete Photo", body: "Are you sure?\nThis action cannot be undone.") { [weak self] in
            guard let self = self else { return }
            
            CoreDataManager.deletePhoto(photo: self.parentVC.photo)
            self.parentVC.dismiss(animated: true)
        }
    }
}
