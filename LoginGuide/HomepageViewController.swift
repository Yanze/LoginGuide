//
//  homepageViewController.swift
//  LoginGuide
//
//  Created by yanze on 9/28/16.
//  Copyright © 2016 yanzeliu. All rights reserved.
//

import UIKit

class HomepageViewController: UIViewController {
    
    var welcomeLabelAnchor: NSLayoutConstraint?
    
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to LoginGuide"
        label.textAlignment = NSTextAlignment.center
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(welcomeLabel)
        
        _ = welcomeLabel.anchor(view.topAnchor, left:view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 40, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 70).first
    }
}
