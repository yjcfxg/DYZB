//
//  UIBarButtonItem+Extension.swift
//  DYZB
//
//  Created by yjcfxg on 2017/7/3.
//  Copyright © 2017年 yjcfxg. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    //类方法
//    class func createItem(imageName : String,highImageName : String, size :CGSize) -> UIBarButtonItem {
//        
//        let btn = UIButton()
//        btn.setImage(UIImage(named: imageName), for: .normal)
//        btn.setImage(UIImage(named: highImageName), for: .highlighted)
//        btn.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//       return UIBarButtonItem(customView: btn)
//    }
    // 便利构造函数：1> convenience开头 2>在构造函数中必须明确调用一个设计的构造函数(self)
    // swift语法，可以传默认参数，在下面要做判断
    convenience init(imageName : String,highImageName : String, size :CGSize) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        if highImageName != "" {
            
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        }
    
        btn.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.init(customView: btn)
        
    }
    
}
