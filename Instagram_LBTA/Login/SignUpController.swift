//
//  ViewController.swift
//  Instagram_LBTA
//
//  Created by Niko Kim on 30.10.2020.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
  let plusPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
    button.layer.cornerRadius = 70
    button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
    return button
  }()
  
  @objc func handlePlusPhoto() {
    
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    
    present(imagePickerController, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
      plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
    } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
      plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
    plusPhotoButton.layer.masksToBounds = true
    plusPhotoButton.layer.borderColor = UIColor.black.cgColor
    plusPhotoButton.layer.borderWidth = 3
    
    dismiss(animated: true, completion: nil)
  }
  
  let emailTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Email"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 16)
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  @objc func handleTextInputChange() {
    let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
    
    if isFormValid {
      signUpButton.isEnabled = true
      signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
    } else {
      signUpButton.isEnabled = false
      signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    }
    
  }
  
  let usernameTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Username"
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
  
  let signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign Up", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    button.layer.cornerRadius = 5
    button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    button.isEnabled = false
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    view.addSubview(plusPhotoButton)
    
    plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
    plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    setupInputFields()
  }
  
  @objc func handleSignUp() {
    
    guard let email = emailTextField.text, email.count > 0 else { return }
    guard let username = usernameTextField.text, username.count > 0 else { return }
    guard let password = passwordTextField.text, password.count > 0 else { return }
    
    Firebase.Auth.auth().createUser(withEmail: email, password: password) { (result: AuthDataResult?, error: Error?) in
      
      if let error = error {
        print("Failed to create user:", error)
      }
      
      print("Successfully created user:", result?.user.uid ?? "")
      
      guard let image = self.plusPhotoButton.imageView?.image else { return }
      guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
      
      let filename = NSUUID().uuidString
      
      let storageRef = Storage.storage().reference().child("profile_images").child(filename)
      storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
        
        if let err = err {
          print("Failed to upload profile image:", err)
          return
        }
        
        storageRef.downloadURL { (downloadURL, err) in
          if let err = err {
            print("Failed to fetch downloadURL:", err)
            return
          }
          
          guard let profileImageUrl = downloadURL?.absoluteString else { return }
          print("Successfully uploaded profile image:", profileImageUrl)
          

          guard let uid = result?.user.uid else { return }

          let dictionaryValues = ["username": username, "profile_image": profileImageUrl]
          let values = [uid: dictionaryValues]

          Database.database().reference().child("users").updateChildValues(values) { (err, ref) in
            if let err = err {
              print("Failed to save user info into db:", err)
              return
            }
            print("Successfully saved user into db")
          }
        }
      }
    }
  }
  
  fileprivate func setupInputFields() {
    let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
    
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    stackView.axis = .vertical
    
    view.addSubview(stackView)
    //    NSLayoutConstraint.activate([
    //      stackView.heightAnchor.constraint(equalToConstant: 200)
    //    ])
    
    stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
  }
}

extension UIView {
  func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    
    if let left = left {
      self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    
    if let bottom = bottom {
      self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
    }
    
    if let right = right {
      self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }
    
    if width != 0 {
      self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    if height != 0 {
      self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }
}
