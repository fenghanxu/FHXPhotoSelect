//
//  ImagePickerController.swift
//  sharesChonse
//
//  Created by 冯汉栩 on 2018/6/15.
//  Copyright © 2018年 fenghanxuCompany. All rights reserved.
//

import UIKit
import Photos
//import SPKit
//import BuyerUIConfig

//相簿列表项
struct ImageAlbumItem {
  //相簿名称
  var title:String?
  //相簿内的资源
  var fetchResult:PHFetchResult<PHAsset>
}

class ImagePickerController: UIViewController {
  
  let tableView = UITableView()
  
  //相簿列表项集合
  var items:[ImageAlbumItem] = []
  
  //每次最多可选择的照片数量
  var maxSelected:Int = Int.max
  
  //照片选择完毕后的回调
  var completeHandler:((_ assets:[PHAsset])->())?
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
   
    //申请权限
    PHPhotoLibrary.requestAuthorization({ (status) in
      if status != .authorized {
        return
      }
      
      // 列出所有系统的智能相册
      let smartOptions = PHFetchOptions()
      let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                subtype: .albumRegular,
                                                                options: smartOptions)
      self.convertCollection(collection: smartAlbums)
      
      //列出所有用户创建的相册
      let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
      self.convertCollection(collection: userCollections
        as! PHFetchResult<PHAssetCollection>)
      
      //相册按包含的照片数量排序（降序）
      self.items.sort { (item1, item2) -> Bool in
        return item1.fetchResult.count > item2.fetchResult.count
      }
      
      //异步加载表格数据,需要在主线程中调用reloadData() 方法
      DispatchQueue.main.async{
        self.tableView.reloadData()
        
        //首次进来后直接进入第一个相册图片展示页面（相机胶卷）
        let vc = ImageCollectionViewController()
        vc.title = self.items.first?.title
        vc.assetsFetchResults = self.items.first?.fetchResult
        vc.completeHandler = self.completeHandler
        vc.maxSelected = self.maxSelected        
        self.navigationController?.pushViewController(vc, animated: false)
      }
    })
    
  }
  
  class func ImagePickerView(vc: UIViewController,
                             maxSelected:Int = Int.max,
                             completeHandler:((_ assets:[PHAsset])->())?) {
          let imageVC = ImagePickerController()
          //设置选择完毕后的回调
          imageVC.completeHandler = completeHandler
          //设置图片最多选择的数量
          imageVC.maxSelected = maxSelected
          let nav = UINavigationController(rootViewController: imageVC)
          vc.present(nav, animated: true, completion: nil)
  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        buildUI()
    }
  
  fileprivate func buildUI() {
    view.backgroundColor = UIColor.white
    view.addSubview(tableView)
    
    navigationItem.title = "相册"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(cancel))
    buildSubView()
    buildLayout()
  }
  
  fileprivate func buildSubView() {
    tableView.rowHeight = 55
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ImagePickerCell.self, forCellReuseIdentifier: "kImagePickerCell")
  }
  
  fileprivate func buildLayout() {
    tableView.frame = view.bounds
  }

}

extension ImagePickerController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "kImagePickerCell", for: indexPath) as! ImagePickerCell
    cell.titleLabel.text = items[indexPath.item].title
    cell.countLabel.text = "(\(items[indexPath.item].fetchResult.count))"
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let cell = tableView.cellForRow(at: indexPath) as? ImagePickerCell else { return }    
    let vc = ImageCollectionViewController()
    vc.assetsFetchResults = items[indexPath.item].fetchResult
    vc.title = cell.titleLabel.text
    vc.completeHandler = completeHandler
//    vc.maxSelected = self.maxSelected
    navigationController?.pushViewController(vc, animated: true)
  }
}

extension ImagePickerController {
  
  //转化处理获取到的相簿
  fileprivate func convertCollection(collection:PHFetchResult<PHAssetCollection>){
    for i in 0..<collection.count{
      //获取出但前相簿内的图片
      let resultsOptions = PHFetchOptions()
      resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: false)]
      resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                             PHAssetMediaType.image.rawValue)
      let c = collection[i]
      let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
      //没有图片的空相簿不显示
      if assetsFetchResult.count > 0 {
        let title = titleOfAlbumForChinse(title: c.localizedTitle)
        items.append(ImageAlbumItem(title: title,
                                      fetchResult: assetsFetchResult))
      }
    }
  }
  
  //由于系统返回的相册集名称为英文，我们需要转换为中文
  fileprivate func titleOfAlbumForChinse(title:String?) -> String? {
    if title == "Slo-mo" {
      return "慢动作"
    } else if title == "Recently Added" {
      return "最近添加"
    } else if title == "Favorites" {
      return "个人收藏"
    } else if title == "Recently Deleted" {
      return "最近删除"
    } else if title == "Videos" {
      return "视频"
    } else if title == "All Photos" {
      return "所有照片"
    } else if title == "Selfies" {
      return "自拍"
    } else if title == "Screenshots" {
      return "屏幕快照"
    } else if title == "Camera Roll" {
      return "相机胶卷"
    }
    return title
  }
  
  //取消按钮点击
  @objc func cancel() {
    //退出当前视图控制器
    self.dismiss(animated: true, completion: nil)
  }
  
}

extension UIViewController {
  //HGImagePicker提供给外部调用的接口，同于显示图片选择页面
  func presentHGImagePicker(maxSelected:Int = Int.max,
                            completeHandler:((_ assets:[PHAsset])->())?)
    -> ImagePickerController?{      
        let vc = ImagePickerController()
        //设置选择完毕后的回调
        vc.completeHandler = completeHandler
        //设置图片最多选择的数量
        vc.maxSelected = maxSelected
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        return vc
  }
  
  
}


