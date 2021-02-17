//
//  UMModalCustomChildVC.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 12.02.21.
//

import UIKit 

protocol UMModalCustomChildVCDelegate: AnyObject {
    
    var modalHeight: UMModalHeight { get set }
    
    func changeModalHeight(to modalHeight: UMModalHeight)
}


class UMModalCustomChildVC: UIViewController {
    
    weak var delegate: UMModalCustomChildVCDelegate?
}
