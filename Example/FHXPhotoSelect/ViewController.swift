//
//  ViewController.swift
//  FHXPhotoSelect
//
//  Created by fenghanxu on 08/01/2018.
//  Copyright (c) 2018 fenghanxu. All rights reserved.
//

import UIKit
import FHXPhotoSelect

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let phtotView = SelectPhotoView(limitIconCount: 8)
    
    view.addSubview(phtotView)
    
    phtotView.frame = CGRect(x: 0, y: 300, width: view.bounds.size.width, height: phtotView.viewHeight)
    
  }
  
  
  
}

