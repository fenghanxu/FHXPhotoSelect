//
//  PriviewViewController.swift
//  ImagePreview
//
//  Created by brycegao on 2017/3/29.
//  Copyright © 2017年 brycegao. All rights reserved.
//

import UIKit
//import BuyerUIConfig

//import SPKit
//预览图片
class PreviewViewController: UIViewController {
    var networkList = [String]()
    var localList = [String]()
    var imageList = [UIImage]()
    var index: Int?
    var collectionView: UICollectionView?        //设置分页
    var pageControl: UIPageControl?     //小圆点（可以配置颜色）
    var choose = Choose.Unknow
    //构造函数
  init(imageString: [String] = [String](), imageArr: [UIImage] = [UIImage](), index: Int = 0, chooses: PreviewViewController.Choose) {
      choose = chooses
      switch choose {
      case .Local:
        self.localList = imageString
      case .Network:
        self.networkList = imageString
      case .Image:
        self.imageList = imageArr
      default:
        break
      }
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
  enum Choose {
    case Local
    case Network
    case Image
    case Unknow
  }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
      
        view.backgroundColor = UIColor.white
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = view.bounds.size    
        layout.scrollDirection = .horizontal
        
        automaticallyAdjustsScrollViewInsets = false
        
        collectionView = UICollectionView(frame: self.view.bounds,
                                          collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(PreviewCell.self, forCellWithReuseIdentifier: "kPreviewCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.isPagingEnabled = true //分屏
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView!)
        
        let indexPath = IndexPath(item: index!, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
        
        pageControl = UIPageControl()
        pageControl?.center = CGPoint(x: UIScreen.main.bounds.width/2,
                                      y: UIScreen.main.bounds.height - 30)   //设置位置为屏幕底部
        pageControl?.currentPage = index!
        switch choose {
        case .Local:
          pageControl?.numberOfPages = localList.count   //小圆点总数
        case .Network:
          pageControl?.numberOfPages = networkList.count    //小圆点总数
        case .Image:
          pageControl?.numberOfPages = imageList.count    //小圆点总数
        default:
          break
        }
      
        pageControl?.isUserInteractionEnabled = false   //不支持点击
        self.view.addSubview(pageControl!)
      
        let singleClick = UITapGestureRecognizer(target: self,
                                                 action: #selector(singleClick(_:)))
        singleClick.numberOfTapsRequired = 1   //点击次数
        singleClick.numberOfTouchesRequired = 1  //手指个数
        view.addGestureRecognizer(singleClick)
    }
  
  //显示或者隐藏导航栏
  @objc func singleClick(_ tap: UITapGestureRecognizer) {
    navigationController?.popViewController(animated: true)
  }

}


//数据
extension PreviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            //只有一个section
      switch choose{
      case .Local:
        return localList.count
      case .Network:
        return networkList.count
      case .Image:
        return imageList.count
      default:
        return 0
      }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      switch choose {
      case .Local:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kPreviewCell", for: indexPath) as! PreviewCell
        cell.imageView?.image = UIImage(named: localList[indexPath.item]) ?? UIImage()
        return cell
      case .Network:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kPreviewCell", for: indexPath) as! PreviewCell
        let url = URL(string:networkList[indexPath.item])
        let data = try! Data(contentsOf: url!)
        cell.imageView?.image = UIImage(data: data)

        return cell
      case .Image:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kPreviewCell", for: indexPath) as! PreviewCell
        cell.imageView?.image = imageList[indexPath.item]
        return cell
      default:
        return UICollectionViewCell()
      }
    }

}

//事件
extension PreviewViewController: UICollectionViewDelegate {
    
    //即将显示
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? PreviewCell {
            cell.resize()
            
            self.pageControl?.currentPage = indexPath.item
        }
    }
}








