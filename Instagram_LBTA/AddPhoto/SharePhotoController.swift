//
//  SharePhotoController.swift
//  Instagram_LBTA
//
//  Created by Niko Kim on 09.11.2020.
//

import UIKit

class SharePhotoController: UIViewController {
  
  var selectedImage: UIImage? {
    didSet {
      self.imageView.image = selectedImage
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    
    setupImageAndTextViews()
  }
  
  let imageView: UIImageView = {
    let iv = UIImageView()
    iv.backgroundColor = .red
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  let textView: UITextView = {
    let tv = UITextView()
    tv.font = .systemFont(ofSize: 14)
    return tv
  }()
  
  fileprivate func setupImageAndTextViews() {
    let containerView = UIView()
    containerView.backgroundColor = .white
    
    view.addSubview(containerView)
    
    containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    
    containerView.addSubview(imageView)
    imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
    
    containerView.addSubview(textView)
    textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
  }
  
  @objc fileprivate func handleShare() {
    
  }
}
