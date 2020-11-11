//
//  Post.swift
//  Instagram_LBTA
//
//  Created by Niko Kim on 11.11.2020.
//

import UIKit

struct Post {
  let imageURL: String
  
  init(dictionary: [String: Any]) {
    self.imageURL = dictionary["imageURL"] as? String ?? ""
  }
}
