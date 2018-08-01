//
//  SelectPhotoView.swift
//  sharesChonse
//
//  Created by 冯汉栩 on 2018/6/19.
//  Copyright © 2018年 fenghanxuCompany. All rights reserved.
//

import UIKit
//import BuyerUIConfig
//import SPKit
import Photos
//用于监视图片数量发生变化就执行代理出外面，可以利用到当前的图片显示，也可能利用图片数量控制控件是否显示。
protocol SelectPhotoViewDelegate:NSObjectProtocol {
  func selectPhotoView(view:SelectPhotoView, imageChange: [UIImage])
}

public class SelectPhotoView: UIView {
  
  weak var delegate:SelectPhotoViewDelegate?
  
  public var viewHeight:CGFloat = 0
  fileprivate var limitImageCount:Int = 0
  fileprivate let defaultImg = Asserts.findImages(named: "default-1")
  fileprivate var paddingX: CGFloat = 5
  fileprivate var paddingY: CGFloat = 5
  fileprivate var itemHeight: CGFloat = 0
  fileprivate let flowLayout = UICollectionViewFlowLayout()
  fileprivate let collectionView: UICollectionView!
  
  fileprivate var images = [UIImage]() {
    didSet{ collectionView.reloadData() }
  }

  public init(limitIconCount: CGFloat) {
    limitImageCount = Int(limitIconCount)
    let a = ceil(Double(limitImageCount)/4.0)
    viewHeight = CGFloat(a*100)
    itemHeight = (UIScreen.main.bounds.size.width-CGFloat(30)-(paddingX*CGFloat(3)))/CGFloat(4)
    collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    super.init(frame: CGRect.zero)
    buildUI()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension SelectPhotoView {
  
  fileprivate func buildUI(){
    addSubview(collectionView)
    buildSubView()
//    buildLayout()
  }
  
  fileprivate func buildSubView(){
    flowLayout.itemSize = CGSize(width: itemHeight, height: itemHeight)
    flowLayout.minimumLineSpacing = paddingY
    flowLayout.minimumInteritemSpacing = paddingX
    flowLayout.sectionInset = UIEdgeInsets(top:    5,
                                           left:   15,
                                           bottom: 0,
                                           right:  15)
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isPagingEnabled = true
    collectionView.bounces = false
    collectionView.isScrollEnabled = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = UIColor.white
    collectionView.register(SelectPhotoCell.self, forCellWithReuseIdentifier: "kSelectPhotoCell")
    collectionView.register(PhotoBtnCell.self, forCellWithReuseIdentifier: "kPhotoBtnCell")
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    let collectionViewT:NSLayoutConstraint = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy:.equal, toItem:self, attribute:.top, multiplier:1.0, constant: 0.0)
    collectionView.superview?.addConstraint(collectionViewT)
    let collectionViewL:NSLayoutConstraint = NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy:.equal, toItem:self, attribute:.left, multiplier:1.0, constant: 0.0)
    collectionView.superview?.addConstraint(collectionViewL)
    let collectionViewR:NSLayoutConstraint = NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy:.equal, toItem:self, attribute:.right, multiplier:1.0, constant: 0.0)
    collectionView.superview?.addConstraint(collectionViewR)
    let collectionViewB:NSLayoutConstraint = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy:.equal, toItem:self, attribute:.bottom, multiplier:1.0, constant: 0.0)
    collectionView.superview?.addConstraint(collectionViewB)
  }
  
  fileprivate func PHAssetToImageList(assetList:[PHAsset]) -> [UIImage]{
    var imageList = [UIImage]()
    
    // 新建一个默认类型的图像管理器imageManager
    let imageManager = PHImageManager.default()
    
    // 新建一个PHImageRequestOptions对象
    let imageRequestOption = PHImageRequestOptions()
    
    // PHImageRequestOptions是否有效
    imageRequestOption.isSynchronous = true
    
    // 缩略图的压缩模式设置为无
    imageRequestOption.resizeMode = .none
    
    // 缩略图的质量为高质量，不管加载时间花多少
    imageRequestOption.deliveryMode = .highQualityFormat
    
    for item in assetList {
      // 按照PHImageRequestOptions指定的规则取出图片
      imageManager.requestImage(for: item, targetSize: CGSize.init(width: 1080, height: 1920), contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
        (result, _) -> Void in
        guard let image = result else { return }
        //        image = result!
        imageList.append(image)
      })
    }
    return imageList
    
  }
  
  fileprivate func getViewController() -> UIViewController? {
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

extension SelectPhotoView: UICollectionViewDelegate, UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if images.isEmpty {
      return 1
    }else{
      if images.count >= limitImageCount{
        return images.count
      }else{
        return images.count + 1
      }
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if images.isEmpty {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kPhotoBtnCell", for: indexPath) as! PhotoBtnCell
      cell.photoBtnCellCount(iconTotal: limitImageCount, remainingQuantity: 0)
      return cell
    }else{
      if images.count >= limitImageCount{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kSelectPhotoCell", for: indexPath) as! SelectPhotoCell
        cell.setImage(image: images[indexPath.item])
        cell.item = indexPath.item
        cell.delegate = self
        return cell
      }else{
        if indexPath.item != images.count {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kSelectPhotoCell", for: indexPath) as! SelectPhotoCell
          cell.setImage(image: images[indexPath.item])
          cell.item = indexPath.item
          cell.delegate = self
          return cell
        }else {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kPhotoBtnCell", for: indexPath) as! PhotoBtnCell
          cell.photoBtnCellCount(iconTotal: limitImageCount, remainingQuantity: limitImageCount - images.count)
          return cell
        }
      }
    }
    
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    if images.isEmpty {
      imageBtnEvent()
    }else{
      if images.count >= limitImageCount{
        //放大图片
        let previewVC = PreviewViewController(imageArr: images, index: indexPath.item, chooses: .Image)
//        sp.viewController?.sp.push(vc: previewVC)
        if let nav = getViewController()?.navigationController {
          nav.pushViewController(previewVC, animated: true)
        }
      }else{
        if indexPath.item == images.count {
//          if images.count == limitImageCount { return }
          imageBtnEvent()
        }else {
          //放大图片
          let previewVC = PreviewViewController(imageArr: images, index: indexPath.item, chooses: .Image)
//          sp.viewController?.sp.push(vc: previewVC)
          if let nav = getViewController()?.navigationController {
            nav.pushViewController(previewVC, animated: true)
          }
        }
      }
    }
    
  }
}

// MARK: 相册 Delegate
extension SelectPhotoView: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
    let type: String = (info[UIImagePickerControllerMediaType] as! String)
    
    //当选择的类型是图片
    if type == "public.image" {
      let image = info[UIImagePickerControllerOriginalImage] as! UIImage
      
      if images.count < limitImageCount {
        images.append(image)
      }
      delegate?.selectPhotoView(view: self, imageChange: images)
      picker.dismiss(animated: true, completion: nil)
    }
  }
  
  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//    sp.viewController?.dismiss(animated: true, completion: nil)
    getViewController()?.dismiss(animated: true, completion: nil)
  }
}

extension SelectPhotoView {
  /// 获取图片数量（用于外面获取图片数组数据）
  func getImages() -> [UIImage] {
    return images
  }
  
  /// 图片按钮Event
  @objc func imageBtnEvent() {
    let alertController = UIAlertController(title: "请选择头像来源",
                                            message: "相册",
                                            preferredStyle: .actionSheet)
    
    let action_1: UIAlertAction = UIAlertAction(title: "从相册选择",
                                                style: .default) { [weak self] (action) in
                                                  self?.pushPhoto(buttonIndex: 1)
    }
    let action_2: UIAlertAction = UIAlertAction(title: "拍照",
                                                style: .default) { [weak self] (action) in
                                                  self?.pushPhoto(buttonIndex: 2)
    }
    let cancel: UIAlertAction = UIAlertAction(title: "取消",
                                              style: .cancel) { (action) in
    }
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      alertController.addAction(action_1)
    }
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      alertController.addAction(action_2)
    }
    alertController.addAction(cancel)
//    sp.viewController?.present(alertController,animated: true,completion: nil)
    getViewController()?.present(alertController,animated: true,completion: nil)
  }
  
  /// 跳转相册
  func pushPhoto(buttonIndex: Int) {
    var sourceType: UIImagePickerControllerSourceType = .photoLibrary
    switch buttonIndex {
    case 1: // 从相册选择
      let maxSelected = limitImageCount - images.count
      ImagePickerController.ImagePickerView(vc: getViewController()!, maxSelected: maxSelected) {[weak self] (PHAssetList) in
        guard let base = self else { return }
        if base.images.count + PHAssetList.count > base.limitImageCount { return }
        base.images += base.PHAssetToImageList(assetList: PHAssetList)
        base.delegate?.selectPhotoView(view: base, imageChange: base.images)
        base.collectionView.reloadData()
      }
      return
    case 2: // 拍照
      sourceType = .camera
    default: return
    }
    let pickerVC = UIImagePickerController()
    pickerVC.view.backgroundColor = .white
    pickerVC.delegate = self
    pickerVC.allowsEditing = true
    pickerVC.sourceType = sourceType
//    sp.viewController?.present(pickerVC, animated: true, completion: nil)
    getViewController()?.present(pickerVC,animated: true,completion: nil)
  }
}

/// cell代理
extension SelectPhotoView: SelectPhotoCellDelegate {
  func selectPhotoCell(deleteItem: Int) {
    if deleteItem >= images.count { return }
    images.remove(at: deleteItem)
    delegate?.selectPhotoView(view: self, imageChange: images)
  }
}
