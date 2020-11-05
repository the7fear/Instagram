//
//  LoginController.swift
//  Instagram_LBTA
//
//  Created by Niko Kim on 04.11.2020.
//

import UIKit
import Firebase

class LoginController: UIViewController {
  
  let logoContainerView: UIView = {
    let view = UIView()
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
    view.addSubview(logoImageView)
    logoImageView.contentMode = .scaleAspectFill
    logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
    logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
    return view
  }()
  
  let emailTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Email"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 16)
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  let passwordTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Password"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.isSecureTextEntry = true
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 16)
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  @objc func handleTextInputChange() {
    let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
    
    if isFormValid {
      loginButton.isEnabled = true
      loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
    } else {
      loginButton.isEnabled = false
      loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    }
  }
  
  let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Login", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    button.layer.cornerRadius = 5
    button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    button.isEnabled = false
    return button
  }()
  
  @objc fileprivate func handleLogin() {
    
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
      if let error = error {
        print("Failed to login", error)
      }
      print("Successfully logged back in with user:", user?.user.uid ?? "")
      
      guard let mainTabBarController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? MainTabBarController else { return }
      
//      guard let mainTabBarController = UIApplication.shared.connectedScenes
//              .filter({$0.activationState == .foregroundActive})
//              .map({$0 as? UIWindowScene})
//              .compactMap({$0})
//              .first?.windows
//              .filter({$0.isKeyWindow}).first as? MainTabBarController else { return }
      mainTabBarController.setupViewControllers()
      
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  let dontHaveAccountButton: UIButton = {
    let button = UIButton(type: .system)
    let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
    attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
    button.setAttributedTitle(attributedTitle, for: .normal)
    button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(logoContainerView)
    
    logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
    
    view.backgroundColor = .white
    
    navigationController?.isNavigationBarHidden = true
    
    view.addSubview(dontHaveAccountButton)
    dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    
    seuptInputField()
  }
  
  fileprivate func seuptInputField() {
    
    let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
    
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    stackView.spacing = 10
    
    view.addSubview(stackView)
    stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  @objc fileprivate func handleShowSignUp() {
    
    let signUpController = SignUpController()
//    signUpController.modalPresentationStyle = .fullScreen
    navigationController?.pushViewController(signUpController, animated: true)
  }
}
