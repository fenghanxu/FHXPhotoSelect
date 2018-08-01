//
//  PreviewCell.swift
//  ImagePreview
//
//  Created by brycegao on 2017/3/29.
//  Copyright © 2017年 brycegao. All rights reserved.
//

import UIKit
//import SPKit
//import BuyerUIConfig

class PreviewCell: UICollectionViewCell {
  var scrollView: UIScrollView?
  var imageView: UIImageView?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
    
    scrollView = UIScrollView(frame: self.contentView.bounds)
    self.contentView.addSubview(scrollView!)    //添加全屏子视图
    scrollView?.delegate = self
    scrollView?.minimumZoomScale = 0.5    //缩小倍数
    scrollView?.maximumZoomScale = 5.0    //放大倍数
    scrollView?.backgroundColor = UIColor.black
    self.imageView = UIImageView()
    imageView?.frame = (scrollView?.bounds)!    //scrollview和imageview一样大
    imageView?.isUserInteractionEnabled = true
    imageView?.contentMode = .scaleAspectFit
    scrollView?.addSubview(imageView!)
    
    let singleClick = UITapGestureRecognizer(target: self,
                                             action: #selector(singleClick(_:)))
    singleClick.numberOfTapsRequired = 1   //点击次数
    singleClick.numberOfTouchesRequired = 1  //手指个数
    
    let doubleClick = UITapGestureRecognizer(target: self,
                                             action: #selector(doubleClick(_:)))
    doubleClick.numberOfTapsRequired = 2
    doubleClick.numberOfTouchesRequired = 1
    
    singleClick.require(toFail: doubleClick)   //双击监听失效时才响应单击事件
    
    self.imageView?.addGestureRecognizer(singleClick)
    self.imageView?.addGestureRecognizer(doubleClick)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //计算缩放比例，保证图片完整的显示出来
  func getScale(size: CGSize) -> CGSize {
    let width = size.width
    let height = size.height
    let radioWH = width / UIScreen.main.bounds.width
    let radioHT = height / UIScreen.main.bounds.height
    let radio = max(radioWH, radioHT)
    return CGSize(width: width/radio, height: height/radio)
  }
  
  func resize() {
    scrollView?.zoomScale = 1.0   //默认不缩放
    
    if let image = imageView?.image {
      imageView?.frame.size = getScale(size: image.size)   //缩放图片到合适大小
      imageView?.center = (scrollView?.center)!  //位置居中
    }
  }
  
  //显示或者隐藏导航栏
  @objc func singleClick(_ tap: UITapGestureRecognizer) {
    if let nav = getViewController()?.navigationController {
      nav.popViewController(animated: true)
    }
  }
  
  //放大或者缩小图片
  @objc func doubleClick(_ tap: UITapGestureRecognizer) {
    UIView.animate(withDuration: 1, animations: {
      if self.scrollView?.zoomScale == 1.0 {
        self.scrollView?.zoomScale = 5.0
      } else {
        self.scrollView?.zoomScale = 1.0
      }
    })
  }
  
  //查找所在的UIViewController
  func getViewController() -> UIViewController? {
    for view in sequence(first: self.superview, next: {$0?.superview}) {
      if let responder = view?.next{
        if responder.isKind(of: UIViewController.self) {
          return responder as? UIViewController
        }
      }
    }
    return nil
  }
  
}


//事件
extension PreviewCell: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return self.imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    //设置图片位置
    let centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2:scrollView.center.x
    
    let centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2:scrollView.center.y
    imageView?.center = CGPoint(x: centerX, y: centerY)
  }
}








