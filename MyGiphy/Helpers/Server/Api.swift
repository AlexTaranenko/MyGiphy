//
//  Api.swift
//  MyGiphy
//
//  Created by Alex on 6/1/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

extension Request {
  var url: URL {
    return URL(string: "https://api.giphy.com/v1/\(endpoint)")!
  }
}

enum Api: Request {
  
  case search(String)
  
  
  var endpoint: String {
    switch self {
    case .search:
      return "stickers/search"
    }
  }
  
  var method: HTTPMethod {
    return .get
  }
  
  var headers: [String : String]? {
    return ["api_key": "KUPr6JRQ5c3SFzYd7ZNfusQHOoTl7EKv"]
  }
  
  var parameters: [String : Any]? {
    switch self {
    case .search(let text):
      return ["q": text, "limit": 10, "offset": 0, "rating": "G", "lang": "en"]
    }
  }
}
