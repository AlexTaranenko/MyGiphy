//
//  URLSession.swift
//  MyGiphy
//
//  Created by Alex on 6/1/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
  case head = "HEAD"
}

protocol Request {
  var url: URL { get }
  var endpoint: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String]? { get }
  var parameters: [String: Any]? { get }
}

extension URLSession {
  func dataTask(with request: Request, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    return dataTask(with: prepareUrlRequest(from: request), completionHandler: completionHandler)
  }
  
  func dataTask<T>(with request: Request, model: T.Type, completionHandler: @escaping (T? , URLResponse?, Error?) -> Void) -> URLSessionDataTask where T: Codable {
    return dataTask(with: prepareUrlRequest(from: request)) { (data, response, error) in
      if let data = data {
        let json = try? JSONDecoder().decode(model, from: data)
        completionHandler(json, response, error)
      } else {
        completionHandler(nil, response, error)
      }
    }
  }
  
  func dataTask(with request: Request, completionHandler: @escaping (Any?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    return dataTask(with: prepareUrlRequest(from: request)) { (data, response, error) in
      if let data = data {
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: [])
          completionHandler(json, response, error)
        } catch {
          completionHandler(nil, response, error)
        }
      } else {
        completionHandler(nil, response, error)
      }
    }
  }
  
  private func prepareUrlRequest(from request: Request) -> URLRequest {
    guard var urlComponents = URLComponents(url: request.url, resolvingAgainstBaseURL: true) else {
      fatalError("Couldn't create url components from url: \(request.url.absoluteString)")
    }
    
    var queryItems: [URLQueryItem] = []
    
    request.parameters?.forEach { (arg) in
      
      let (key, value) = arg
      if value is Int {
        queryItems.append(URLQueryItem(name: key, value: "\(value as! Int)"))
      } else {
        queryItems.append(URLQueryItem(name: key, value: value as? String))
      }
    }
//    request.parameters?.forEach{ (key, value) in
//      queryItems.append(URLQueryItem(name: key, value: value))
//    }
    
    urlComponents.queryItems = queryItems
    
    guard let url = urlComponents.url else {
      fatalError("Couldn't create url with these parameters")
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method.rawValue
    
    request.headers?.forEach{ (key, value) in
      urlRequest.addValue(value, forHTTPHeaderField: key)
    }
    
    return urlRequest
  }
}
