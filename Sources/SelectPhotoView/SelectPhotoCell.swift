//
//  SelectPhotoCell.swift
//  B7iOSBuyer
//
//  Created by 冯汉栩 on 2018/5/22.
//  Copyright © 2018年 com.spzjs.b7iosbuy. All rights reserved.
//

import UIKit
//import SPKit

protocol SelectPhotoCellDelegate: AnyObject {
  func selectPhotoCell(deleteItem: Int)
}

class SelectPhotoCell: UICollectionViewCell {
  
  weak var delegate: SelectPhotoCellDelegate?
  
  var item = -1
  
  fileprivate let imageView = UIImageView()
  fileprivate let deleteBtn = UIButton()
  override init(frame: CGRect) {
    super.init(frame: frame)
    buildUI()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SelectPhotoCell {
  fileprivate func buildUI() {
    contentView.addSubview(imageView)
    contentView.addSubview(deleteBtn)    
    buildSubView()
    buildLayout()
  }
  
  private func buildSubView() {
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    deleteBtn.addTarget(self,
                        action: #selector(deleteEvent),
                        for: .touchUpInside)
    deleteBtn.setImage(Asserts.findImages(named: "comment_picture_delete_36"), for: .normal)
  }
  
  private func buildLayout() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    let Gtop:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy:.equal, toItem:contentView, attribute:.top, multiplier:1.0, constant: 0.0)
    imageView.superview?.addConstraint(Gtop)
    let Gleft:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy:.equal, toItem:contentView, attribute:.left, multiplier:1.0, constant: 0.0)
    imageView.superview?.addConstraint(Gleft)
    let Gright:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .right, relatedBy:.equal, toItem:contentView, attribute:.right, multiplier:1.0, constant: 0.0)
    imageView.superview?.addConstraint(Gright)
    let Gbottom:NSLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy:.equal, toItem:contentView, attribute:.bottom, multiplier:1.0, constant: 0.0)
    imageView.superview?.addConstraint(Gbottom)
    
    deleteBtn.translatesAutoresizingMaskIntoConstraints = false
    let cancelImgVtop:NSLayoutConstraint = NSLayoutConstraint(item: deleteBtn, attribute: .top, relatedBy:.equal, toItem:contentView, attribute:.top, multiplier:1.0, constant: 0.0)
    deleteBtn.superview?.addConstraint(cancelImgVtop)
    let cancelImgVLeft:NSLayoutConstraint = NSLayoutConstraint(item: deleteBtn, attribute: .right, relatedBy:.equal, toItem:contentView, attribute:.right, multiplier:1.0, constant: 0.0)
    deleteBtn.superview?.addConstraint(cancelImgVLeft)
    let cancelImgVRightHeight:NSLayoutConstraint = NSLayoutConstraint(item: deleteBtn, attribute: .height, relatedBy:.equal, toItem:nil, attribute: .notAnAttribute, multiplier:0.0, constant:20)
    deleteBtn.addConstraint(cancelImgVRightHeight)
    let cancelImgVRightWidth:NSLayoutConstraint = NSLayoutConstraint(item: deleteBtn, attribute: .width, relatedBy:.equal, toItem:nil, attribute: .notAnAttribute, multiplier:0.0, constant:20)
    deleteBtn.addConstraint(cancelImgVRightWidth)
    
  }
}

extension SelectPhotoCell {
  func setImage(image: UIImage) {
    imageView.image = image
  }
  
  @objc func deleteEvent() {
    if item == -1 { return }
    delegate?.selectPhotoCell(deleteItem: item)
  }
}
