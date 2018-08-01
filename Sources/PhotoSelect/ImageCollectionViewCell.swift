//
//  ImageCollectionViewCell.swift
//  sharesChonse
//
//  Created by 冯汉栩 on 2018/6/15.
//  Copyright © 2018年 fenghanxuCompany. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
  
  var imageView = UIImageView()
  var selectedIcon  = UIImageView()
  
  //设置是否选中
  open override var isSelected: Bool {
    didSet{
      if isSelected {
        selectedIcon.image = Asserts.findImages(named: "CellBlueSelected")
      }else{
        selectedIcon.image = Asserts.findImages(named: "CellGreySelected")
      }
    }
  }
  
  //播放动画，是否选中的图标改变时使用
  func playAnimate() {
    //图标先缩小，再放大
    UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction,
                            animations: {
                              UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                                                 animations: {
                                                  self.selectedIcon.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                              })
                              UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4,
                                                 animations: {
                                                  self.selectedIcon.transform = CGAffineTransform.identity
                              })
    }, completion: nil)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    buildUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func buildUI() {
    contentView.addSubview(imageView)
    contentView.addSubview(selectedIcon)
    
    selectedIcon.image = Asserts.findImages(named: "CellGreySelected")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    
    imageView.frame = self.bounds
  }
    
    override func layoutSubviews() {
        selectedIcon.frame = CGRect(x: bounds.size.width-25, y: 0, width: 25, height: 25)
    }
  
}
