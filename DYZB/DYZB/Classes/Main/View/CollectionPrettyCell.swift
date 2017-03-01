//
//  CollectionPrettyCell.swift
//  DYZB
//
//  Created by 1 on 16/9/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit


class CollectionPrettyCell: UICollectionViewCell {
    
    @IBOutlet weak var icon_image: UIImageView!
    
    var anchor: AnchorModel? {
        didSet {
            
            guard let anchor = anchor else { return }
            // 3.设置封面图片
            guard let iconURL = NSURL(string: anchor.vertical_src) else { return }
            icon_image.kf_setImageWithURL(iconURL)
            
        }
    }

}
