//
//  LoginController.swift
//  Instagram_LBTA
//
//  Created by Niko Kim on 04.11.2020.
//

import UIKit

class LoginController: UIViewController {
  
  let signUpbutton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Don't have an account? Sign Up.", for: .normal)
    button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationController?.isNavigationBarHidden = true
    
    view.addSubview(signUpbutton)
    signUpbutton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
  }
  
  @objc fileprivate func handleShowSignUp() {
    
    let signUpController = SignUpController()
//    signUpController.modalPresentationStyle = .fullScreen
    navigationController?.pushViewController(signUpController, animated: true)
  }
}
