//
//  CustomImageView.swift
//  Instagram_LBTA
//
//  Created by Niko Kim on 12.11.2020.
//

import UIKit

class CustomImageView: UIImageView {
  
  var lastURLUsedToLoadImage: String?
  
  func  loadImage(urlString: String) {
    
    lastURLUsedToLoadImage = urlString
    
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print("Failed to fetch post image:", error)
        return
      }
      
      if url.absoluteString != self.lastURLUsedToLoadImage {
        return
      }
      
      guard let imageData = data else { return }
      
      let photoImage = UIImage(data: imageData)
      DispatchQueue.main.async {
        self.image = photoImage
      }
    }.resume()
  }
}
