//
//  PhotoUnsplashWebVC.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 05.02.21.
//

import UIKit
import WebKit

class PhotoUnsplashWebVC: UIViewController {
    
    var url: URL?
    var webView: WKWebView!
    
    
    init(urlString: String) {
        self.url = URL(string: urlString)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        webView = WKWebView()
        view    = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = url {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
}
