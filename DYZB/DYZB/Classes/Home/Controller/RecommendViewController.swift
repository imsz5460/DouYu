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

//    //懒加载属性
//    private lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()
//    private lazy var bigdataGroup: AnchorGroup = AnchorGroup()
//    private lazy var prettyGroup: AnchorGroup = AnchorGroup()
    
    
    private lazy var recommendVM: RecommendVM = RecommendVM()
    
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
        collectionView.contentInset = UIEdgeInsetsMake(100, 0, kTabbarH, 0)
        
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
        recommendVM.loadData { 
            self.collectionView.reloadData()
        }
        /*
//        let nowTime = NSDate().timeIntervalSince1970
//      
////        http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1488167931.49921
//        
//        let parameters = ["limit": "4","offset":"0", "time" :"\(nowTime)"]
//         //创建队列组
////        let  group: dispatch_group_t = dispatch_group_create();
//        // 2.创建Group
//        let dGroup = dispatch_group_create()
//        
//        // 3.请求第一部分推荐数据
//        dispatch_group_enter(dGroup)
//        
//        //多次执行耗时的异步操作
////        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//        
//            NetworkTools.requestDate(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time" :"\(nowTime)"]) { (result) in
//                
//                guard let resultDict = result as? [String : NSObject] else { return }
//                guard let resultArray = resultDict["data"] as? [[String: NSObject]] else {return}
//                
//                // 3.1.设置组的属性
//                self.bigdataGroup.tag_name = "热门"
//                self.bigdataGroup.icon_name = "home_header_hot"
//                
//                for dict in resultArray {
//                    self.bigdataGroup.anchors.append(AnchorModel(dict: dict))
//                }
//                
//                dispatch_group_leave(dGroup)
//            }
//        
//        // 3.3.离开组
////        }
//        
//        
//        dispatch_group_enter(dGroup)
//        //多次执行耗时的异步操作
////        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//        
//            NetworkTools.requestDate(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result) in
//                
//                self.prettyGroup.tag_name = "颜值"
//                self.prettyGroup.icon_name = "home_header_phone"
//                
//                guard let resultDict = result as? [String : NSObject] else { return }
//                guard let resultArray = resultDict["data"] as? [[String: NSObject]] else {return}
//                for dict in resultArray {
//                    self.prettyGroup.anchors.append(AnchorModel(dict: dict))
//                }
//                
//                // 3.3.离开组
//                dispatch_group_leave(dGroup)
//            }
//        
////        }
//
//        
//        dispatch_group_enter(dGroup)
//        
//        //多次执行耗时的异步操作
////        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//        
//            NetworkTools.requestDate(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (result) in
//                
//                guard let resultDict = result as? [String : NSObject] else { return }
//                guard let resultArray = resultDict["data"] as? [[String: NSObject]] else {return}
//                for dict in resultArray {
//                    self.anchorGroups.append(AnchorGroup(dict: dict))
//                }
//                
//                dispatch_group_leave(dGroup)
//            }
//        
//        
////        }
//        
//        
//        
//        dispatch_group_notify(dGroup, dispatch_get_global_queue(0,0)) {
//            self.anchorGroups.insert(self.prettyGroup, atIndex: 0)
//            self.anchorGroups.insert(self.bigdataGroup, atIndex: 0)
//            
//            
//            
//            // 1.展示推荐数据
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                self.collectionView.reloadData()
//            })
//            
//        }
        */
        
    }
}

    


//MARK: -UICollectionViewDataSource
extension RecommendViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return recommendVM.anchorGroups.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return recommendVM.anchorGroups[section].anchors.count

    }
   
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
//        var cell: UICollectionViewCell
        
        if indexPath.section == 1 {
           let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kPrettyCellID, forIndexPath: indexPath)
            as! CollectionPrettyCell
            let group = recommendVM.anchorGroups[indexPath.section]
            cell.anchor = group.anchors[indexPath.item]
            return cell
        } else {
           let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kNormalCellID, forIndexPath: indexPath) as! CollectionNormalCell
           
                
            let group = recommendVM.anchorGroups[indexPath.section]
            cell.anchor = group.anchors[indexPath.item]
            
            
            return cell
        }
        
        
//        cell.backgroundColor = UIColor.redColor()
//        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

//         1.取出section的HeaderView
    let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kHeaderViewID, forIndexPath: indexPath)
        as! CollectionHeaderView
        
        headerView.group = recommendVM.anchorGroups[indexPath.section]
        
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