//
//  ImageCollectionViewController.swift
//  sharesChonse
//
//  Created by 冯汉栩 on 2018/6/15.
//  Copyright © 2018年 fenghanxuCompany. All rights reserved.
//

import UIKit
import Photos
//import BuyerUIConfig

class ImageCollectionViewController: UIViewController {

  let flowLayout = UICollectionViewFlowLayout()
  
  var collectionView:UICollectionView!

  //取得的资源结果，用了存放的PHAsset
  var assetsFetchResults:PHFetchResult<PHAsset>?
  
  //带缓存的图片管理对象
  var imageManager:PHCachingImageManager!
  
  //缩略图大小
  var assetGridThumbnailSize:CGSize!
  
  //每次最多可选择的照片数量
  var maxSelected:Int = Int.max
  
  //照片选择完毕后的回调
  var completeHandler:((_ assets:[PHAsset])->())?
  
  //完成按钮
   let buttomView = ImageButtomView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(buttomView)
    buttomView.delegate = self
    
    view.addSubview(buttomView)
    buttomView.translatesAutoresizingMaskIntoConstraints = false
    let buttomViewH:NSLayoutConstraint = NSLayoutConstraint(item: buttomView, attribute: .height, relatedBy:.equal, toItem:nil, attribute: .notAnAttribute, multiplier:0.0, constant:40)
    buttomView.addConstraint(buttomViewH)
    let buttomViewL:NSLayoutConstraint = NSLayoutConstraint(item: buttomView, attribute: .left, relatedBy:.equal, toItem:view, attribute:.left, multiplier:1.0, constant: 0.0)
    buttomView.superview?.addConstraint(buttomViewL)
    let buttomViewR:NSLayoutConstraint = NSLayoutConstraint(item: buttomView, attribute: .right, relatedBy:.equal, toItem:view, attribute:.right, multiplier:1.0, constant: 0.0)
    buttomView.superview?.addConstraint(buttomViewR)
    let buttomViewB:NSLayoutConstraint = NSLayoutConstraint(item: buttomView, attribute: .bottom, relatedBy:.equal, toItem:view, attribute:.bottom, multiplier:1.0, constant: 0.0)
    buttomView.superview?.addConstraint(buttomViewB)
    
    collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    view.addSubview(collectionView)

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    let Gtop:NSLayoutConstraint = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy:.equal, toItem:view, attribute:.top, multiplier:1.0, constant: 0.0)
    collectionView.superview?.addConstraint(Gtop)
    let Gleft:NSLayoutConstraint = NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy:.equal, toItem:view, attribute:.left, multiplier:1.0, constant: 0.0)
    collectionView.superview?.addConstraint(Gleft)
    let Gright:NSLayoutConstraint = NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy:.equal, toItem:view, attribute:.right, multiplier:1.0, constant: 0.0)
    collectionView.superview?.addConstraint(Gright)
    let Gbottom:NSLayoutConstraint = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy:.equal, toItem:buttomView, attribute:.top, multiplier:1.0, constant: 0.0)
    collectionView.superview?.addConstraint(Gbottom)
    
    //根据单元格的尺寸计算我们需要的缩略图大小
    let scale = UIScreen.main.scale
    let cellSize = (self.collectionView.collectionViewLayout as!
      UICollectionViewFlowLayout).itemSize
    assetGridThumbnailSize = CGSize(width: cellSize.width*scale ,
                                    height: cellSize.height*scale)
    
    //背景色设置为白色（默认是黑色）
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.bounces = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = UIColor.white
    collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier:"kImageCollectionViewCell")
    //初始化和重置缓存
    self.imageManager = PHCachingImageManager()
    self.resetCachedAssets()
    

    //允许多选
    self.collectionView.allowsMultipleSelection = true
    
    //添加导航栏右侧的取消按钮
    let rightBarItem = UIBarButtonItem(title: "取消", style: .plain,
                                       target: self, action: #selector(cancel))
    self.navigationItem.rightBarButtonItem = rightBarItem
    

  }
  
  //重置缓存
  func resetCachedAssets(){
    self.imageManager.stopCachingImagesForAllAssets()
  }
  
  
  //取消按钮点击
  @objc func cancel() {
    //退出当前视图控制器
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
  
  //获取已选择个数
  func selectedCount() -> Int {
    return self.collectionView.indexPathsForSelectedItems?.count ?? 0
  }

}

//图片缩略图集合页控制器UICollectionViewDataSource,UICollectionViewDelegate协议方法的实现
extension ImageCollectionViewController:UICollectionViewDataSource
,UICollectionViewDelegate{
  //CollectionView项目
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return self.assetsFetchResults?.count ?? 0
  }
  
  // 获取单元格
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //获取storyboard里设计的单元格，不需要再动态添加界面元素
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
    let asset = self.assetsFetchResults![indexPath.row]
    //获取缩略图
    self.imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize,
                                   contentMode: .aspectFill, options: nil) {
                                    (image, nfo) in
                                    cell.imageView.image = image!
    }
//    aspectFill
    return cell
  }
  
  //单元格选中响应
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    
    if let cell = collectionView.cellForItem(at: indexPath)
      as? ImageCollectionViewCell{
      //获取选中的数量
      let count = self.selectedCount()
      //如果选择的个数大于最大选择数
      if count > self.maxSelected {
        //设置为不选中状态
        collectionView.deselectItem(at: indexPath, animated: false)
        //弹出提示
        let title = "你最多只能选择\(self.maxSelected)张照片"
        let alertController = UIAlertController(title: title, message: nil,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title:"我知道了", style: .cancel,
                                         handler:nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
      }
        //如果不超过最大选择数
      else{
        //改变完成按钮数字，并播放动画
        buttomView.completeButton.num = count
        if count > 0 && !buttomView.completeButton.isEnabled{
          buttomView.completeButton.isEnabled = true
        }
        cell.playAnimate()
      }
      
    }
  }
  
  //单元格取消选中响应
  func collectionView(_ collectionView: UICollectionView,
                      didDeselectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath)
      as? ImageCollectionViewCell{
      //获取选中的数量
      let count = self.selectedCount()
      buttomView.completeButton.num = count
      //改变完成按钮数字，并播放动画
      if count == 0{
        buttomView.completeButton.isEnabled = false
      }
      cell.playAnimate()
    }
  }
}

//cell之间的间距代理
extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
  //cell的大小
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = CGSize(width: view.bounds.size.width/4, height: view.bounds.size.width/4)
    return size
  }
  //cell的内间距
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(0, 0, 0, 0)
  }
  //cell的上下间距
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  //cell的左右间距
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}

extension ImageCollectionViewController: ImageButtomViewDelegate {
  func imageButtomView(view: ImageButtomView, finishBtnClick btn: ImageCompleteButton) {
      //取出已选择的图片资源
      var assets:[PHAsset] = []
      if let indexPaths = self.collectionView.indexPathsForSelectedItems{
        for indexPath in indexPaths{
          assets.append(assetsFetchResults![indexPath.row] )
        }
      }
      //调用回调函数
      self.navigationController?.dismiss(animated: true, completion: {
        self.completeHandler?(assets)
      })
  }
}

