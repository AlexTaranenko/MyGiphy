//
//  SearchTableViewCell.swift
//  MyGiphy
//
//  Created by Alex on 6/1/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {
  
  static let identifier = "searchCellIdentifier"
  
  private let photoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .white
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 12)
    label.textColor = .black
    label.text = ""
    return label
  }()
  
  private let searchLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .lightGray
    label.text = ""
    return label
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none
    
    setupViews()
    setupLayoutConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  // MARK: - Public
  
  func prepareSearchCell(model: SearchModel) {
    titleLabel.text = model.title
    searchLabel.text = model.searchText
    photoImageView.kf.indicatorType = .activity
  }
  
  func setupPhotoImageView(model: SearchModel) {
    guard let url = URL(string: model.url) else { return }
    photoImageView.kf.setImage(with: url)
  }
  
  func cancelDownloadImage() {
    photoImageView.kf.cancelDownloadTask()
  }
  
  // MARK: - Private
  
  private func setupViews() {
    [photoImageView, titleLabel, searchLabel].forEach({ contentView.addSubview($0) })
  }
  
  private func setupLayoutConstraints() {
    photoImageView.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, paddingTop: 10, bottom: contentView.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10, left: contentView.safeAreaLayoutGuide.leftAnchor, paddingLeft: 16, right: nil, paddingRight: 0, width: contentView.bounds.width / 2, height: contentView.bounds.width / 3)
    
    titleLabel.anchor(top: photoImageView.topAnchor, paddingTop: 0, bottom: searchLabel.topAnchor, paddingBottom: 5, left: photoImageView.rightAnchor, paddingLeft: 10, right: contentView.safeAreaLayoutGuide.rightAnchor, paddingRight: 16, width: 0, greaterHeight: 20)

    searchLabel.anchor(top: titleLabel.bottomAnchor, paddingTop: 5, bottom: contentView.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10, left: photoImageView.rightAnchor, paddingLeft: 10, right: contentView.safeAreaLayoutGuide.rightAnchor, paddingRight: 16, width: 0, height: 20)
    
  }
}
