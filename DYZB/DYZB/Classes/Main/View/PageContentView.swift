//
//  PageContentView.swift
//  DYZB
//
//  Created by shizhi on 17/2/23.
//  Copyright © 2017年 shizhi. All rights reserved.
//

import UIKit

private let kContentCellID = "ContentCellID"

class PageContentView: UIView {
    
    // MARK:- 定义属性
    private var childVcs: [UIViewController]
    private weak var parentVc: UIViewController?
    
    
    //懒加载
    private lazy var collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        
        // 2.创建UICollectionView
        let collectionview = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionview.bounces = false
        collectionview.dataSource = self
        collectionview.pagingEnabled = true
        collectionview.scrollsToTop = false
        collectionview.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        
        
        return collectionview
       
    }()
    
    // MARK:- 构造函数
    
    init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController?) {
      
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        //设置UI
        setUpUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK:设置UI界面
extension PageContentView {
    //设置UI
    private func setUpUI() {
        //将所有的子控制器添加到父控制器中
        for childVc in childVcs {
            parentVc?.addChildViewController(childVc)
        }
        //添加collectionview
        addSubview(collectionview)
        collectionview.frame = bounds
        
    }
    
}

//MARK:数据源方法
extension PageContentView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCellWithReuseIdentifier(kContentCellID, forIndexPath: indexPath)
        //移除之前的view
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        //添加当前的view
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
        
    }
 

}

