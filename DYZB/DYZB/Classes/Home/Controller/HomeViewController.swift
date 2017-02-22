//
//  HomeViewController.swift
//  DYZB
//
//  Created by shizhi on 17/2/22.
//  Copyright © 2017年 shizhi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        setUpUI()
    }
    
    
}


// MARK:- 设置UI界面
extension HomeViewController {
    
    private func setUpUI() {
        setUpNavigationbar()
    }
    
    
    
    private func setUpNavigationbar() {
        //设置左侧Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName:"logo")
        //设置右侧Item
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrCodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrCodeItem]
        
    }
}