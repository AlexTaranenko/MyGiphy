//
//  UIViewController+Extensions.swift
//  MyGiphy
//
//  Created by Alex on 6/2/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerExtensionProtocol {
  
  var rootViewController: UIViewController? { get }
  
  func presentAlert(message: String, title: String)
}

extension UIViewController: ViewControllerExtensionProtocol {
  
  var rootViewController: UIViewController? {
    var viewController = UIApplication.shared.keyWindow?.rootViewController
    if let navigationController = viewController as? UINavigationController {
      viewController = navigationController.viewControllers.first
    }
    
    if let tabBarController = viewController as? UITabBarController {
      viewController = tabBarController.selectedViewController
    }
    
    return viewController
  }

  func presentAlert(message: String, title: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    rootViewController?.present(alertController, animated: true, completion: nil)
  }

}
