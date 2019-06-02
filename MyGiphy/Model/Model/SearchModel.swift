//
//  SearchModel.swift
//  MyGiphy
//
//  Created by Alex on 6/2/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import RealmSwift

class SearchModel: Object {
  
  @objc dynamic var id = ""
  @objc dynamic var title = ""
  @objc dynamic var searchText = ""
  @objc dynamic var url = ""
    
  static func createSearchModel(mapping: SearchMapping, searchText: String) -> SearchModel {
    let model = SearchModel()
    model.id = mapping.id
    model.title = mapping.title
    model.searchText = searchText
    model.url = mapping.images.original_still.url
    return model
  }
}
