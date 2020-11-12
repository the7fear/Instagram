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
      guard let imageURL = post?.imageURL else { return }
      photoImageView.loadImage(urlString: imageURL)
    }
  }
  
  let photoImageView: CustomImageView = {
    let iv = CustomImageView()
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
}
