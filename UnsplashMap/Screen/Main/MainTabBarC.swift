//
//  MainTabBarVC.swift
//  UnsplashMapped
//
//  Created by Kai Zheng on 02.02.21.
//

import UIKit

class MainTabBarC: UITabBarController, UMLoadingVCProtocol {
    
    var loadingVC: UMLoadingVC!
    private let addButton = UMCircleButton(size: .large, appearance: .dark, symbol: SFSymbol.plus)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [createPhotosVC(), createMapVC()]
        
        configureTabBarAppearance()
        configureAddButton()
        configureFirstStart()
    }
    
    
    private func createPhotosVC() -> UINavigationController {
        let photosVC = PhotosVC()
        photosVC.title = "Photos"
        photosVC.tabBarItem.image = SFSymbol.photo
        photosVC.tabBarItem.selectedImage = SFSymbol.photoFill
        
        return UINavigationController(rootViewController: photosVC)
    }
    
    
    private func createMapVC() -> UIViewController {
        let mapVC = MapVC()
        mapVC.title = "Map"
        mapVC.tabBarItem.image = SFSymbol.map
        mapVC.tabBarItem.selectedImage = SFSymbol.mapFill
        
        return mapVC
    }
    
    
    private func configureTabBarAppearance() {
        tabBar.tintColor = UMColor.blackToWhite
        tabBar.unselectedItemTintColor = UMColor.blackToWhite
        tabBar.barTintColor = UMColor.lightGrayToBlack
        
        tabBar.items!.first!.titlePositionAdjustment    = UIOffset(horizontal: -10.0, vertical: 0.0)
        tabBar.items!.last!.titlePositionAdjustment     = UIOffset(horizontal: 10.0, vertical: 0.0)
    }
    
    
    //MARK: - AddButton
    
    private func configureAddButton() {
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: addButton.frame.size.height),
            addButton.widthAnchor.constraint(equalToConstant: addButton.frame.size.width),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8 + UMLayout.onlyOniPhoneXType(-20))
        ])
        
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
    }
    
    
    @objc private func addButtonAction() {
        self.showLoadingView()
        
        UnsplashNetworkManager.shared.requestARandomPhotoWithLocation { [weak self] error in
            self?.dismissLoadingView() { [weak self] in
                if let error = error {
                    self?.showPopupVC(title: "Error", body: error.message)
                }
            }
        }
    }
    
    
    private func configureFirstStart() {
        if UserDefaultsManager.shared.firstStart {
            showPopupVC(title: "Welcome!", body: "Generate random photos from Unsplash and explore their locations.")
            UserDefaultsManager.shared.firstStart = false
        }
    }
}
