//
//  AnchorGroup.swift
//  DYZB
//
//  Created by shizhi on 17/2/28.
//  Copyright © 2017年 shizhi. All rights reserved.
//

import UIKit

class AnchorGroup: NSObject {
    var room_list: [[String: NSObject]]? {
        didSet {
            guard let room_list = room_list else {return}
            for dict in room_list {
                anchors.append(AnchorModel(dict: dict))
            }
        }
        
    }
    /// 组显示的标题
    var tag_name: String = ""
    /// 组显示的图标
    var icon_name: String = "home_header_normal"
    /// 游戏对应的图标
    var icon_url : String = ""
    
    var anchors: [AnchorModel] = [AnchorModel]()
    
    override init() {
        
    }
    
    init(dict: [String: NSObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}
