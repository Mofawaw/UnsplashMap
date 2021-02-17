//
//  PhotoImageView.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 04.02.21.
//

import UIKit

class PhotoImageView: UIView {
    
    var imageView: UIImageView!
    
    enum Size {
        case regular, map
    }
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addUMItemShadow()
    }
    
    
    private func configure() {
        imageView = UIImageView()
        
        addSubview(imageView)
        translatesAutoresizingMaskIntoConstraints = false
        
        imageView.clipsToBounds     = true
        imageView.contentMode       = .scaleAspectFill
        imageView.backgroundColor   = UMColor.lightGrayToBlack

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func downloadImage(photo: Photo, size: Size) {
        let urlString = size == .regular ? photo.imageURL : photo.imageURLMap
        
        ImageNetworkManager.shared.requestImage(fromURLString: urlString) { [weak self] image in
            guard let self = self else { return }
            
            UIView.transition(with: self.imageView, duration: 0.3, options: .transitionCrossDissolve) {
                self.imageView.image = image
            }
        }
    }
    
    
    func reset() {
        imageView.image = nil
    }
}
