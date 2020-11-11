//
//  UserProfileCell.swift
//  Instagram_LBTA
//
//  Created by Niko Kim on 11.11.2020.
//

import UIKit

class UserProfileCell: UICollectionViewCell {
  
  var post: Post? {
    didSet {
      fetchImage()
    }
  }
  
  let photoImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(photoImageView)
    photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  fileprivate func fetchImage() {
    
    guard let imageURL = post?.imageURL else { return }
    guard let url = URL(string: imageURL) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print("Failed to fetch post image:", error)
        return
      }
      
      guard let imageData = data else { return }
      
      let photoImage = UIImage(data: imageData)
      DispatchQueue.main.async {
        self.photoImageView.image = photoImage
      }
    }.resume()
  }
}
