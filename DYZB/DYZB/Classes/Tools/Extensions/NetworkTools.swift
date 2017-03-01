//
//  NetworkTools.swift
//  DYZB
//
//  Created by shizhi on 17/2/26.
//  Copyright © 2017年 shizhi. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}



class NetworkTools  {

    
    
    
}

extension NetworkTools {
    
    class func requestDate(method: MethodType, URLString: URLStringConvertible, parameters: [String : AnyObject]?, finishedBlock:(result: AnyObject) -> ()) {
        
        let method = method == .GET ? Method.GET : Method.POST
        Alamofire.request(method, URLString, parameters: parameters).responseJSON { (response) in
           
            guard let result = response.result.value else {
                print(response.result.error)
                
                return
            }
            finishedBlock(result: result)
            
        }
    }
    
//    Alamofire.request(method, URLString, parameters: parameters).responseJSON { (response) in
//    // 3.获取结果
//    guard let result = response.result.value else {
//    print(response.result.error)
//    return
//    }

    
}
