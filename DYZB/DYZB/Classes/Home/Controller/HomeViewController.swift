//
//  HomeViewController.swift
//  DYZB
//
//  Created by shizhi on 17/2/22.
//  Copyright © 2017年 shizhi. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {
    
     // MARK:- 懒加载属性
    private lazy var pageTitleView: PageTitleView = {
        [weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles )
        
        titleView.delegate = self
        return titleView
    }()
    
    
    private lazy var pageContentView: PageContentView = {
        [weak self] in
      let  contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH
      let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
    
        var childVcs = [UIViewController]()
        for _ in 0..<4 {
            let childVc = UIViewController()
            childVc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(childVc)
            
        }
        
    
    let contentview = PageContentView(frame: contentFrame, childVcs: childVcs, parentVc: self)
        contentview.delegate = self

        
        return contentview
    
    }()
    
    
    
    override func viewDidLoad() {
        setUpUI()
    }
    
    
}


// MARK:- 设置UI界面
extension HomeViewController {
    
    private func setUpUI() {
        // 0.不需要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false

        setUpNavigationbar()
        
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
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

// MARK:- 遵守PageTitleViewDelegate协议
extension HomeViewController : PageTitleViewDelegate {
    func pageTitleView(titleView : PageTitleView, selectedIndex: Int) {
        pageContentView.setCurrentIndex(selectedIndex)
    }
}


// MARK:- 遵守PageContentViewDelegate协议
extension HomeViewController : PageContentViewDelegate {
    func pageContentView(contentView : PageContentView, progress: CGFloat) {
        pageTitleView.changeLabel(progress)
    }
}