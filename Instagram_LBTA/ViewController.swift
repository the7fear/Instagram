//
//  ViewController.swift
//  Instagram_LBTA
//
//  Created by Niko Kim on 30.10.2020.
//

import UIKit

class ViewController: UIViewController {
  
  let plusPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
    button.layer.cornerRadius = 70
    return button
  }()
  
  let emailTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Email"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 16)
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  let usernameTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Username"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 16)
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  let passwordTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Password"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.isSecureTextEntry = true
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 16)
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  let signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign Up", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
    button.layer.cornerRadius = 5
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    view.addSubview(plusPhotoButton)
    plusPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
    plusPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
    plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
    
    setupInputField()
  }
  
  fileprivate func setupInputField() {
    let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    stackView.axis = .vertical
    
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 20),
      stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
      stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
      stackView.heightAnchor.constraint(equalToConstant: 200)
    ])
  }
  
  
}

