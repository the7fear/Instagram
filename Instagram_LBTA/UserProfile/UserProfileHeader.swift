//
//  UserProfileHeader.swift
//  Instagram_LBTA
//
//  Created by Niko Kim on 02.11.2020.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
  
  var user: User? {
    didSet {
      setupProfileImage()
    }
  }
  
  let profileImageView: UIImageView = {
    let iv = UIImageView()
    iv.backgroundColor = .red
    return iv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .blue
    
    addSubview(profileImageView)
    profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
    profileImageView.layer.cornerRadius = 80 / 2
    profileImageView.clipsToBounds = true
    }
  
  fileprivate func setupProfileImage() {
    
    guard let profileImageUrl = user?.profileImageUrl else { return }
    guard let url = URL(string: profileImageUrl) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, err) in
      if let err = err {
        print("Failed to fetch data", err)
        return
      }
      
      guard let data = data else { return }
      let image = UIImage(data: data)
      
      DispatchQueue.main.async {
        self.profileImageView.image = image
      }
      
    }.resume()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
