//
//  SearchViewModel.swift
//  MyGiphy
//
//  Created by Alex on 6/1/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import RealmSwift

protocol SearchViewModelProtocol {
  
  typealias SearchHandler = (Bool, String) -> Void
  
  var itemsArray: [SearchModel]? { get set }
  var numberOfRows: Int { get }
  
  func getDataFromDB(with text: String)
  
  func searchImage(searchText: String, handler: @escaping (SearchHandler))
  
  func getModel(by indexPath: IndexPath) -> SearchModel?
}

class SearchViewModel: SearchViewModelProtocol {
  
  private var session = URLSession(configuration: .default)
  
  var itemsArray: [SearchModel]? = nil
  var numberOfRows: Int {
    guard let items = itemsArray else { return 0 }
    return items.count
  }
  
  init() {
  }
  
  func getDataFromDB(with text: String) {
    let realm = try! Realm()
    let items = realm.objects(SearchModel.self)
    if !text.isEmpty {
      itemsArray = Array(items).filter({ $0.searchText == text })
    } else {
      itemsArray = Array(items)
    }
  }
  
  func searchImage(searchText: String, handler: @escaping (SearchHandler)) {
    session.dataTask(with: Api.search(searchText), model: SearchResponseMapping.self) { [weak self] (mapping, response, error) in
      if let mapping = mapping {
        self?.saveObjects(mappingsArray: mapping.data, searchText: searchText)
        handler(true, mapping.data.isEmpty ? "Not found." : "")
      } else {
        if let error = error {
          handler(false, error.localizedDescription)
        }
      }
    }.resume()
  }
  
  private func saveObjects(mappingsArray: [SearchMapping], searchText: String) {
    let realm = try! Realm()
    for mapping in mappingsArray {
      let array = realm.objects(SearchModel.self)
      let filterArray = array.filter({ $0.id == mapping.id })
      if filterArray.isEmpty {
        let model = SearchModel.createSearchModel(mapping: mapping, searchText: searchText)
        try! realm.write {
          realm.add(model)
        }
      }
    }
  }
  
  
  func getModel(by indexPath: IndexPath) -> SearchModel? {
    guard let items = itemsArray else { return nil }
    let model = items[indexPath.row]
    return model
  }
}
