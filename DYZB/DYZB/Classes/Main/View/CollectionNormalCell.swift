//
//  CollectionNormalCell.swift
//  DYZB
//
//  Created by shizhi on 17/2/25.
//  Copyright © 2017年 shizhi. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionNormalCell: UICollectionViewCell {

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
