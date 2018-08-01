//
//  PhotoBtnCell.swift
//  B7iOSBuyer
//
//  Created by 冯汉栩 on 2018/5/23.
//  Copyright © 2018年 com.spzjs.b7iosbuy. All rights reserved.
//

import UIKit
//import Linger
//import BuyerUIConfig
//import SPKit

class PhotoBtnCell: UICollectionViewCell {
  
  func photoBtnCellCount(iconTotal:Int, remainingQuantity iconCount:Int){
    titleLB.text = "\(iconCount)/\(iconTotal)"
  }
  
  fileprivate let imageView = UIImageView()
  fileprivate let titleLB = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    buildUI()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension PhotoBtnCell {
  fileprivate func buildUI() {
    addSubview(imageView)
    addSubview(titleLB)
    
    buildSubView()
//    buildLayout()
  }
  
  private func buildSubView() {
    layer.borderColor = UIColor.gray.cgColor
    layer.borderWidth = 1
    imageView.image = Asserts.findImages(named: "icon_comment_camera_60")
    titleLB.font = UIFont.systemFont(ofSize: 12)
    titleLB.textColor = UIColor.gray
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    let imageViewCenterY:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy:.equal, toItem:self, attribute:.centerY, multiplier:1.0, constant: -10.0)
    imageView.superview?.addConstraint(imageViewCenterY)
    let imageViewCenterX:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy:.equal, toItem:self, attribute:.centerX, multiplier:1.0, constant: 0.0)
    imageView.superview?.addConstraint(imageViewCenterX)
    
    titleLB.translatesAutoresizingMaskIntoConstraints = false
    let titleLBX:NSLayoutConstraint = NSLayoutConstraint(item: titleLB, attribute: .centerX, relatedBy:.equal, toItem:self, attribute:.centerX, multiplier:1.0, constant: 0.0)
    titleLB.superview?.addConstraint(titleLBX)
    let titleLBT:NSLayoutConstraint = NSLayoutConstraint(item: titleLB, attribute: .top, relatedBy:.equal, toItem:imageView, attribute:.bottom, multiplier:1.0, constant: 5.0)
    titleLB.superview?.addConstraint(titleLBT)

  }

}
