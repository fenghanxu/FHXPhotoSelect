//
//  ImagePickerCell.swift
//  sharesChonse
//
//  Created by 冯汉栩 on 2018/6/15.
//  Copyright © 2018年 fenghanxuCompany. All rights reserved.
//

import UIKit
//import SPKit

class ImagePickerCell: UITableViewCell {

  var titleLabel = UILabel()
  var countLabel = UILabel()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    buildUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - UI
extension ImagePickerCell {
  fileprivate func buildUI() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(countLabel)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    countLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let buttomViewL:NSLayoutConstraint = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy:.equal, toItem:contentView, attribute:.left, multiplier:1.0, constant: 15.0)
    titleLabel.superview?.addConstraint(buttomViewL)
    let buttomViewCenterY:NSLayoutConstraint = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy:.equal, toItem:contentView, attribute:.centerY, multiplier:1.0, constant: 0.0)
    titleLabel.superview?.addConstraint(buttomViewCenterY)
    
    let countLabelL:NSLayoutConstraint = NSLayoutConstraint(item: countLabel, attribute: .left, relatedBy:.equal, toItem:titleLabel, attribute:.right, multiplier:1.0, constant: 15.0)
    countLabel.superview?.addConstraint(countLabelL)
    let countLabelY:NSLayoutConstraint = NSLayoutConstraint(item: countLabel, attribute: .centerY, relatedBy:.equal, toItem:contentView, attribute:.centerY, multiplier:1.0, constant: 0.0)
    countLabel.superview?.addConstraint(countLabelY)

  }
  
}


