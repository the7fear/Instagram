//
//  PhotoSelectorController.swift
//  Instagram_LBTA
//
//  Created by Niko Kim on 08.11.2020.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  fileprivate let headerId = "headerId"
  fileprivate let cellId = "cellId"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .systemYellow
    collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    
    setupNavigationButtons()
    fetchPhoto()
  }
  
  var images = [UIImage]()
  
  fileprivate func fetchPhoto() {
    
    let fetchOptions = PHFetchOptions()
    fetchOptions.fetchLimit = 10
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    fetchOptions.sortDescriptors = [sortDescriptor]
    let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    allPhotos.enumerateObjects { (asset, count, stop) in
      
      let imageManager = PHImageManager.default()
      let targetSize = CGSize(width: 350, height: 350)
      let options = PHImageRequestOptions()
      options.isSynchronous = true
      
      imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, info) in
        if let image = image {
          self.images.append(image)
        }
      }
      
      if count == allPhotos.count - 1 {
        self.collectionView.reloadData()
      }
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
    header.backgroundColor = .red
    return header
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let width = view.frame.width
    return .init(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 1, left: 0, bottom: 0, right: 0)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
    cell.photoImageView.image = images[indexPath.item]
//    cell.backgroundColor = .blue
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (view.frame.width - 3) / 4
    return .init(width: width, height: width)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  func setupNavigationButtons() {
    navigationController?.navigationBar.tintColor = .black
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
  }
  
  @objc fileprivate func handleNext() {
    
  }
  
  @objc fileprivate func handleCancel() {
    dismiss(animated: true, completion: nil)
    
    guard let mainTabBarController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? MainTabBarController else { return }
//    let mainTabBarController = MainTabBarController()
    mainTabBarController.setupViewControllers()
    
  }
}
