//
//  LoginCell.swift
//  LoginGuide
//
//  Created by yanze on 9/23/16.
//  Copyright © 2016 yanzeliu. All rights reserved.
//

import UIKit

protocol LoginCellDelegate {
    func loginButtonPressed()
}

class LoginCell: UICollectionViewCell {
    var delegate: LoginCellDelegate?
    
    
    let logoImageView: UIImageView = {
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let emailTextField: leftPaddedTextField = {
        let textField = leftPaddedTextField()
        textField.placeholder = "Enter username"
        textField.font?.withSize(12)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
//        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField: leftPaddedTextField = {
        let textField = leftPaddedTextField()
        textField.placeholder = "Enter password"
        textField.font?.withSize(12)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type:.system)
        button.setTitle("Login", for:.normal)
        button.setTitleColor(.white, for:.normal)
        button.backgroundColor = UIColor(red:247/255, green: 154/255, blue: 27/255, alpha: 1)
        button.addTarget(self, action: #selector(buttonPressed), for:.touchUpInside)
       return button
    }()

    func buttonPressed() {
        if (delegate != nil) {
            delegate?.loginButtonPressed()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logoImageView)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        
        _ = logoImageView.anchor(centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -150, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 30)
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = emailTextField.anchor(logoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 50, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 30)
        emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = passwordTextField.anchor(emailTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 15, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 30)
        passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = loginButton.anchor(passwordTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 15, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 30)
        loginButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class leftPaddedTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
}
