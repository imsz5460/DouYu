//
//  RecommendVMController.swift
//  DYZB
//
//  Created by shizhi on 17/3/3.
//  Copyright © 2017年 shizhi. All rights reserved.
//

import UIKit

class RecommendVM: NSObject {    
    //懒加载属性
    lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()
    private lazy var bigdataGroup: AnchorGroup = AnchorGroup()
    private lazy var prettyGroup: AnchorGroup = AnchorGroup()
    
    func loadData(finishCallback:() -> ())  {
        let nowTime = NSDate().timeIntervalSince1970
        
        //        http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1488167931.49921
        
        let parameters = ["limit": "4","offset":"0", "time" :"\(nowTime)"]
        //创建队列组
        //        let  group: dispatch_group_t = dispatch_group_create();
        // 2.创建Group
        let dGroup = dispatch_group_create()
        
        // 3.请求第一部分推荐数据
        dispatch_group_enter(dGroup)
        
        //多次执行耗时的异步操作
        //        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        
        NetworkTools.requestDate(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time" :"\(nowTime)"]) { (result) in
            
            guard let resultDict = result as? [String : NSObject] else { return }
            guard let resultArray = resultDict["data"] as? [[String: NSObject]] else {return}
            
            // 3.1.设置组的属性
            self.bigdataGroup.tag_name = "热门"
            self.bigdataGroup.icon_name = "home_header_hot"
            
            for dict in resultArray {
                self.bigdataGroup.anchors.append(AnchorModel(dict: dict))
            }
            
            dispatch_group_leave(dGroup)
        }
        
        // 3.3.离开组
        //        }
        
        
        dispatch_group_enter(dGroup)
        //多次执行耗时的异步操作
        //        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        
        NetworkTools.requestDate(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result) in
            
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            
            guard let resultDict = result as? [String : NSObject] else { return }
            guard let resultArray = resultDict["data"] as? [[String: NSObject]] else {return}
            for dict in resultArray {
                self.prettyGroup.anchors.append(AnchorModel(dict: dict))
            }
            
            // 3.3.离开组
            dispatch_group_leave(dGroup)
        }
        
        //        }
        
        
        dispatch_group_enter(dGroup)
        
        //多次执行耗时的异步操作
        //        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        
        NetworkTools.requestDate(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (result) in
            
            guard let resultDict = result as? [String : NSObject] else { return }
            guard let resultArray = resultDict["data"] as? [[String: NSObject]] else {return}
            for dict in resultArray {
                self.anchorGroups.append(AnchorGroup(dict: dict))
            }
            
            dispatch_group_leave(dGroup)
        }
        
        
        //        }
        
        dispatch_group_notify(dGroup, dispatch_get_global_queue(0,0)) {
            
            self.anchorGroups.insert(self.prettyGroup, atIndex: 0)
            self.anchorGroups.insert(self.bigdataGroup, atIndex: 0)
            finishCallback()
            
        }
    }

}
