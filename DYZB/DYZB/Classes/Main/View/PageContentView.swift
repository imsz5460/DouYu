//
//  PageContentView.swift
//  DYZB
//
//  Created by shizhi on 17/2/23.
//  Copyright © 2017年 shizhi. All rights reserved.
//

import UIKit

private let kContentCellID = "ContentCellID"

protocol PageContentViewDelegate : class {
    func pageContentView(contentView : PageContentView, progress : CGFloat)
}

class PageContentView: UIView {
    
    // MARK:- 定义属性
    private var childVcs: [UIViewController]
    private weak var parentVc: UIViewController?
    weak var delegate : PageContentViewDelegate?
    private var isForbidScrollDelegate : Bool = false
    
    
    //懒加载
    private lazy var collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        
        // 2.创建UICollectionView
        let collectionview = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionview.backgroundColor = UIColor.whiteColor()
        
        
//        collectionview.bounces = false
        collectionview.dataSource = self
        
        collectionview.delegate = self
        
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

//MARK:UICollectionView数据源方法
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

//MARK:UICollectionView代理方法
extension PageContentView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // 0.判断是否是点击事件
       if isForbidScrollDelegate { return }
        
        // 1.定义获取需要的数据
        var progress : CGFloat = 0
            
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
       
            // 1.计算progress
            progress = currentOffsetX / scrollViewW
        
        
        // 3.将progress传递给titleView
        delegate?.pageContentView(self, progress: progress)
       
    }


}

// MARK:- 对外暴露的方法
extension PageContentView {
    func setCurrentIndex(currentIndex : Int) {
        
        // 1.记录需要进制执行代理方法
        isForbidScrollDelegate = true
        
        // 2.滚动正确的位置
        let offsetX = CGFloat(currentIndex) * collectionview.frame.width
        collectionview.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}

