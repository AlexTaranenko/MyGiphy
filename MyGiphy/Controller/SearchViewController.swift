//
//  ViewController.swift
//  MyGiphy
//
//  Created by Alex on 6/1/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
  
  private let searchContainerView: UIView = {
    let containerView = UIView()
    containerView.backgroundColor = .white
    return containerView
  }()
  
  private let searchTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    return textField
  }()
  
  private let tableView: UITableView = {
    let table = UITableView()
    table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    return table
  }()
  
  
  private var searchViewModel = SearchViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    setupViews()
    setupLayoutConstraints()
    
    setupTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    searchViewModel.getDataFromDB(with: "")
  }
  
  // MARK: - Private
  
  private func setupViews() {
    searchTextField.delegate = self
    
    searchContainerView.addSubview(searchTextField)
    [searchContainerView, tableView].forEach({ view.addSubview($0) })
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.tableFooterView = UIView(frame: .zero)
    tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
  }
  
  private func setupLayoutConstraints() {
    searchContainerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: tableView.topAnchor, paddingBottom: 0, left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0, right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 0, width: 0, height: 50)
    
    searchTextField.anchor(top: searchContainerView.topAnchor, paddingTop: 10, bottom: searchContainerView.bottomAnchor, paddingBottom: 10, left: searchContainerView.leftAnchor, paddingLeft: 16, right: searchContainerView.rightAnchor, paddingRight: 16, width: 0, height: 40)
    
    tableView.anchor(top: searchContainerView.bottomAnchor, paddingTop: 0, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0, left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0, right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 0, width: 0, height: 0)
  }
  
  // MARK: - UITextFieldDelegate
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    if let text = textField.text {
      if !text.isEmpty || !text.trimmingCharacters(in: .whitespaces).isEmpty {
        searchImage(with: text)
      } else {
        searchViewModel.getDataFromDB(with: "")
        tableView.reloadData()
      }
    }
    return true
  }
  
  private func searchImage(with text: String) {
    searchViewModel.searchImage(searchText: text) { [weak self] (success, message) in
      guard let weakself = self else { return }
      if success {
        if !message.isEmpty { self?.presentAlert(message: message, title: "Info") }
        else {
          DispatchQueue.main.async {
            if let text = weakself.searchTextField.text {
              weakself.searchViewModel.getDataFromDB(with: text)
            } else {
              weakself.searchViewModel.getDataFromDB(with: "")
            }
            weakself.tableView.reloadData()
          }
        }
      } else {
        self?.presentAlert(message: message, title: "Error")
      }
    }
  }
}

// MARK: - Table Cells

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchViewModel.numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let searchCell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as? SearchTableViewCell else { return UITableViewCell() }
    if let model = searchViewModel.getModel(by: indexPath) {
      searchCell.prepareSearchCell(model: model)
    }
    return searchCell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let searchCell = cell as? SearchTableViewCell else { return }
    if let model = searchViewModel.getModel(by: indexPath) {
      searchCell.setupPhotoImageView(model: model)
    }
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let searchCell = cell as? SearchTableViewCell else { return }
    searchCell.cancelDownloadImage()
  }
}
