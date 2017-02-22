//
//  UIBarButtonItem-extension.swift
//  DYZB
//
//  Created by shizhi on 17/2/22.
//  Copyright © 2017年 shizhi. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    //扩充便利构造函数
    convenience init(imageName: String, highImageName: String = "", size: CGSize = CGSizeZero,  target: AnyObject? = nil, action: Selector = nil ) {
        let btn = UIButton()
        //设置btn的颜色
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), forState: .Highlighted)
        }
        if size == CGSizeZero {
            btn.sizeToFit()
        } else {
            btn.frame = CGRect(origin: CGPointZero, size: size) }
        btn.addTarget(target, action: action, forControlEvents: .TouchUpInside )
        self.init(customView: btn)

    }
}
