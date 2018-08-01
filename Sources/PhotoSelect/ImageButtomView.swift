//
//  ImageButtomView.swift
//  sharesChonse
//
//  Created by 冯汉栩 on 2018/6/19.
//  Copyright © 2018年 fenghanxuCompany. All rights reserved.
//

import UIKit
//import BuyerUIConfig

protocol ImageButtomViewDelegate:NSObjectProtocol {
  func imageButtomView(view:ImageButtomView, finishBtnClick btn:ImageCompleteButton)
}
class ImageButtomView: UIView {
  
  weak var delegate:ImageButtomViewDelegate?

  let completeButton = ImageCompleteButton()
 
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
    completeButton.addTarget(target: self, action: #selector(finishSelect))
    completeButton.isEnabled = false
    addSubview(completeButton)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    completeButton.center = CGPoint(x: UIScreen.main.bounds.width - 50, y: 22)
    completeButton.frame.size.width = 70
    completeButton.frame.size.height = 20
  }
  
  @objc func finishSelect(){
    delegate?.imageButtomView(view: self, finishBtnClick: completeButton)
  }
  
}
