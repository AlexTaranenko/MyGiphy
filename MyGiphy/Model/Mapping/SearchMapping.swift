//
//  SearchMapping.swift
//  MyGiphy
//
//  Created by Alex on 6/1/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

struct SearchResponseMapping: Codable {
  
  var data: [SearchMapping]
  
  enum CodingKeys: String, CodingKey {
    case data
  }
}

struct SearchMapping: Codable {
  var images: ImagesMapping
  var title: String
  var id: String
  
  enum CodingKeys: String, CodingKey {
    case images
    case title
    case id
  }
}

struct ImagesMapping: Codable {
  var original_still: OriginalImagesMapping
  
  enum CodingKeys: String, CodingKey {
    case original_still
  }
}

struct OriginalImagesMapping: Codable {
  var url: String
  
  enum CodingKeys: String, CodingKey {
    case url
  }
}
