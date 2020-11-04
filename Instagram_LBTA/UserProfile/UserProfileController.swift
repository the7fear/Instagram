//
//  UserProfileController.swift
//  Instagram_LBTA
//
//  Created by Niko Kim on 02.11.2020.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  fileprivate let headerId = "headerId"
  fileprivate let cellId = "cellId"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.backgroundColor = .white
    collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    
    fetchUser()
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
    header.user = self.user
    return header
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return .init(width: view.frame.width, height: 200)
  }
  
  var user: User?
  
  fileprivate func fetchUser() {
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
      print(snapshot.value ?? "")
      
      guard let dictionary = snapshot.value as? [String: Any] else { return }
      
      self.user = User(dictionary: dictionary)
      
      self.navigationItem.title = self.user?.username
      self.collectionView.reloadData()
      
    } withCancel: { (err) in
      print("Failed to fetch user:", err)
    } // give me this value and then stop observing what is hapenning
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 7
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    cell.backgroundColor = .purple
    return cell
  }
  
  let spacing: CGFloat = 0.5
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (view.frame.width - 2) / 3
    return .init(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
}

struct User {
  let username: String
  let profileImageUrl: String
  
  init(dictionary: [String: Any]) {
    self.username = dictionary["username"] as? String ?? ""
    self.profileImageUrl = dictionary["profile_image"] as? String ?? ""
  }
  
}
