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
    collectionView.backgroundColor = .white
    collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    
    setupNavigationButtons()
    fetchPhoto()
  }
  
  var images = [UIImage]()
  var selectedImage: UIImage?
  var assets = [PHAsset]()
  var header: PhotoSelectorHeader?
  
  fileprivate func assetsFetchOptions() -> PHFetchOptions {
    let fetchOptions = PHFetchOptions()
    fetchOptions.fetchLimit = 30
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    fetchOptions.sortDescriptors = [sortDescriptor]
    return fetchOptions
  }
  
  fileprivate func fetchPhoto() {
    
    let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
    
    DispatchQueue.global(qos: .background).async {
      allPhotos.enumerateObjects { (asset, count, stop) in
        
        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: 200, height: 200)
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, info) in
          if let image = image {
            self.images.append(image)
            self.assets.append(asset)
            if self.selectedImage == nil {
              self.selectedImage = image
            }
          }
        }
        
        if count == allPhotos.count - 1 {
          DispatchQueue.main.async {
            self.collectionView.reloadData()
          }
        }
      }
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedImage = images[indexPath.item]
    self.selectedImage = selectedImage
    collectionView.reloadData()
    
    let indexPath = IndexPath(item: 0, section: 0)
    collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeader
    
    self.header = header
    
    if let selectedImage = selectedImage {
      if let index = self.images.firstIndex(of: selectedImage) {
        let selectedAsset = assets[index]
        
        let imageManager = PHImageManager()
        let targetSize = CGSize(width: 600, height: 600)
        imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { (image, info) in
          header.photoImageView.image = image
        }
      }
    }
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
    let sharePhotoController = SharePhotoController()
    sharePhotoController.selectedImage = header?.photoImageView.image
    navigationController?.pushViewController(sharePhotoController, animated: true)
  }
  
  @objc fileprivate func handleCancel() {
    dismiss(animated: true, completion: nil)
    
    guard let mainTabBarController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? MainTabBarController else { return }
    //    let mainTabBarController = MainTabBarController()
    mainTabBarController.setupViewControllers()
    
  }
}
