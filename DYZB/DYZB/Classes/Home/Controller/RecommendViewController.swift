//
//  RecommendViewController.swift
//  DYZB
//
//  Created by shizhi on 17/2/24.
//  Copyright © 2017年 shizhi. All rights reserved.
//

import UIKit

private let kItemMargin : CGFloat = 10
private let kItemW = (kScreenW - 3 * kItemMargin) / 2
private let kNormalItemH = kItemW * 3 / 4
private let kPrettyItemH = kItemW * 4 / 3
private let kHeaderViewH : CGFloat = 50

private let kHeaderViewID = "kHeaderViewID"
private let kPrettyCellID = "kPrettyCellID"
private let kNormalCellID = "kNormalCellID"



class RecommendViewController: UIViewController {

    //懒加载属性
    private lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()
    
    
    private lazy var collectionView: UICollectionView = {
       [weak self] in
        
        // 1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = kItemMargin
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        //2.创建UIcollectionview
        
        let collectionView = UICollectionView(frame: self!.view.bounds, collectionViewLayout: layout)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]        
        collectionView.backgroundColor = UIColor.whiteColor()
        
        collectionView.registerNib(UINib(nibName: "CollectionNormalCell", bundle: nil),forCellWithReuseIdentifier: kNormalCellID)
        collectionView.registerNib(UINib(nibName: "CollectionPrettyCell", bundle: nil),forCellWithReuseIdentifier: kPrettyCellID)
        
        collectionView.registerNib(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        
        return collectionView
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpUI()
        
        
        loadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


//MARK: UI界面设置
extension RecommendViewController {
    func setUpUI() {
        
        view.addSubview(collectionView)
        
                
    }
    
    
}

extension RecommendViewController {
    func loadData() {
        let nowTime = NSDate().timeIntervalSince1970
        
        print(nowTime)
        
//        http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1488167931.49921
        
        let parameters = ["limit": "4","offset":"0", "time" :"\(nowTime)"]
        NetworkTools.requestDate(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (result) in
            
            guard let resultDict = result as? [String : NSObject] else { return }
            guard let resultArray = resultDict["data"] as? [[String: NSObject]] else {return}
            for dict in resultArray {
                self.anchorGroups.append(AnchorGroup(dict: dict))
            }
            

            
        }
        
    }
    
    
    
}

//MARK: -UICollectionViewDataSource
extension RecommendViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 8
        }
        return 4

    }
   
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
//        var cell: UICollectionViewCell
        
        if indexPath.section == 1 {
           let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kPrettyCellID, forIndexPath: indexPath)
            return cell
        } else {
           let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kNormalCellID, forIndexPath: indexPath) as! CollectionNormalCell
            if indexPath.section != 0 {
                let index = indexPath.section - 2
            let group = self.anchorGroups[index]
                print(indexPath.section-2)
                
                print(indexPath.item)
                print("---------")
                print(group.anchors)
                if index != 1{
                    cell.anchor = group.anchors[indexPath.item]}
            }
            
            return cell
        }
        
        
//        cell.backgroundColor = UIColor.redColor()
//        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        // 1.取出section的HeaderView
    let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kHeaderViewID, forIndexPath: indexPath)
    
    return headerView
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kPrettyItemH)
        } else {
            return CGSize(width: kItemW, height: kNormalItemH)
        }
    }
}