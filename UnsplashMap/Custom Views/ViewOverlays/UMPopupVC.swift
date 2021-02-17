//
//  UMPopupVC.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 02.02.21.
//

import UIKit

extension UIViewController {
    
    func showPopupVC(title: String, body: String, onConfirm: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            let popupVC = UMPopupVC(title: title, body: body, onConfirm: onConfirm)
            popupVC.modalPresentationStyle = .custom
            
            self.present(popupVC, animated: true)
        }
    }
}


class UMPopupVC: UMViewOverlayVC {
    
    let closeButton = UMCircleButton(size: .small, appearance: .light, symbol: SFSymbol.xmark)
    let continueButton = UMCircleButton(size: .medium, appearance: .dark, symbol: SFSymbol.checkmark)
    
    let labelStackView = UIStackView()
    let titleLabel = UMTitleLabel(font: .h3)
    let bodyLabel = UMBodyLabel(font: .body)
    
    var titleText: String
    var bodyText: String
    
    var onConfirm: () -> ()
    
    var tapGesture: UITapGestureRecognizer!
    
    
    init(title: String, body: String, onConfirm: @escaping () -> ()) {
        self.titleText = title
        self.bodyText = body
        self.onConfirm = onConfirm
        
        super.init(nibName: nil, bundle: nil)
        
        transitioningDelegate = self
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTap(sender:)))
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
    }
    
    
    private func configureContainerView() {
        view.addSubview(containerView)
        
        containerView.backgroundColor = UMColor.whiteToDarkGray
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            containerView.widthAnchor.constraint(equalToConstant: 260),
            containerView.heightAnchor.constraint(equalToConstant: 380)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(closeButton)
        containerView.addSubview(continueButton)
        containerView.addSubview(labelStackView)
        
        configureCloseButton()
        configureContinueButton()
        configureLabels()
    }
    
    
    private func configureCloseButton() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: UMLayout.padding),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -UMLayout.padding),
            closeButton.widthAnchor.constraint(equalToConstant: closeButton.frame.size.width),
            closeButton.heightAnchor.constraint(equalToConstant: closeButton.frame.size.height)
        ])
        
        closeButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    }
    
    
    private func configureContinueButton() {
        NSLayoutConstraint.activate([
            continueButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -UMLayout.padding),
            continueButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -UMLayout.padding),
            continueButton.widthAnchor.constraint(equalToConstant: continueButton.frame.size.width),
            continueButton.heightAnchor.constraint(equalToConstant: continueButton.frame.size.height) 
        ])
        
        continueButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
    }
    
    
    private func configureLabels() {
        titleLabel.text = titleText
        bodyLabel.attributedText = bodyText.bodyLineSpaced()
        bodyLabel.numberOfLines = 4
        
        labelStackView.axis         = .vertical
        labelStackView.distribution = .fillProportionally
        labelStackView.spacing      = 20
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(bodyLabel)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 40),
            labelStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: UMLayout.padding),
            labelStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -UMLayout.padding)
        ])
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    @objc private func confirmAction() {
        self.dismiss(animated: true, completion: {
            self.onConfirm()
        })
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
}
