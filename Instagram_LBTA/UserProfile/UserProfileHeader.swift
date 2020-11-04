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
      usernameLabel.text = user?.username
    }
  }
  
  let profileImageView: UIImageView = {
    let iv = UIImageView()
    return iv
  }()
  
  let gridButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
    return button
  }()
  
  let listButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.1)
    return button
  }()
  
  let bookmarkButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.1)
    return button
  }()
  
  let usernameLabel: UILabel = {
    let label = UILabel()
    label.text = "Username"
    label.font = UIFont.boldSystemFont(ofSize: 14)
    return label
  }()
  
  let postsLabel: UILabel = {
    let label = UILabel()
    let attributedText = NSMutableAttributedString(string: "11", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "\nposts", attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 14)]))
    label.attributedText = attributedText
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  let followersLabel: UILabel = {
    let label = UILabel()
    let attributedText = NSMutableAttributedString(string: "0", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "\nfollowers", attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 14)]))
    label.attributedText = attributedText
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  let followingLabel: UILabel = {
    let label = UILabel()
    let attributedText = NSMutableAttributedString(string: "0", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "\nfollowings", attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 14)]))
    label.attributedText = attributedText
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  let editProfileButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Edit Profile", for: .normal)
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.cornerRadius = 3
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    
    addSubview(profileImageView)
    profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
    profileImageView.layer.cornerRadius = 80 / 2
    profileImageView.clipsToBounds = true
    
    setupBottomToolBar()
    
    addSubview(usernameLabel)
    usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
    
    setupUserStatsView()
    
    addSubview(editProfileButton)
    editProfileButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
  }
  
  fileprivate func setupUserStatsView() {
    let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
    stackView.distribution = .fillEqually
    
    addSubview(stackView)
    stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
  }
  
  fileprivate func setupBottomToolBar() {
    
    let topDividerView = UIView()
    topDividerView.backgroundColor = UIColor.lightGray
    
    let bottomDividerView = UIView()
    bottomDividerView.backgroundColor = UIColor.lightGray
    
    let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
    
    stackView.distribution = .fillEqually
    stackView.spacing = 8
    
    addSubview(stackView)
    addSubview(topDividerView)
    addSubview(bottomDividerView)
    
    stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    
    topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    
    bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
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
