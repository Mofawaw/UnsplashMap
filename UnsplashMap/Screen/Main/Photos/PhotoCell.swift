//
//  PhotoCell.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 04.02.21.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    static let reuseID = "PhotoCell"
    let imageView = PhotoImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUp(with photo: Photo) {
        imageView.downloadImage(photo: photo, size: .regular)
    }
    
    
    private func configure() {
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.reset()
    }
}
