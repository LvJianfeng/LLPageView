 //
//  LLColor.swift
//  LLPageView
//
//  Created by LvJianfeng on 2017/12/1.
//  Copyright © 2017年 LvJianfeng. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        guard hex.count >= 6 else {
            return nil
        }
        // 大写
        var tempHex = hex.uppercased()
        
        if tempHex.hasPrefix("0x") || tempHex.hasPrefix("##") {
            tempHex = (tempHex as NSString).substring(from: 2)
        }
        
        if tempHex.hasPrefix("#") {
            tempHex = (tempHex as NSString).substring(from: 1)
        }
        
        // 取出RGB
        var range = NSRange.init(location: 0, length: 2)
        let rHex = (tempHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (tempHex as NSString).substring(with: range)
        range.location = 4
        let bHex = (tempHex as NSString).substring(with: range)
        
        // 十六进制转数字
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        Scanner.init(string: rHex).scanHexInt32(&r)
        Scanner.init(string: gHex).scanHexInt32(&g)
        Scanner.init(string: bHex).scanHexInt32(&b)
        
        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
    }
    
    class func randomColor() -> UIColor {
        return UIColor.init(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    class func getRGBDelta(_ firstColor: UIColor,_ secondColor: UIColor) -> (CGFloat, CGFloat, CGFloat) {
        let firstRGB = firstColor.getRGB()
        let secondRGB = secondColor.getRGB()
        
        return (firstRGB.0 - secondRGB.0, firstRGB.1 - secondRGB.1, firstRGB.2 - secondRGB.2)
    }
    
    func getRGB() -> (CGFloat, CGFloat, CGFloat) {
        guard let components = cgColor.components else {
            fatalError("颜色数值非RGB格式")
        }
        
        return (components[0]*255, components[1]*255, components[2]*255)
    }
}
