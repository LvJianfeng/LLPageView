//
//  LLTitleStyle.swift
//  LLPageView
//
//  Created by LvJianfeng on 2017/11/30.
//  Copyright © 2017年 LvJianfeng. All rights reserved.
//

import UIKit

class LLTitleStyle {
    // TopMargin
    var topMargin: CGFloat = 64.0
    
    // 标题高度
    var titleHeight: CGFloat = 44.0
    
    // 文本颜色
    var normalColor: UIColor = UIColor.init(r: 0, g: 0, b: 0)
    // 选中文本颜色
    var selectedColor: UIColor = UIColor.init(r: 255, g: 0, b: 152)
    
    // 文本大小
    var font: UIFont = UIFont.systemFont(ofSize: 15.0)
    
    // 是否允许滚动
    var isScrollEnable: Bool = true
    
    // 如果允许滚动时的间距设置
    var itemMargin: CGFloat = 30
    
    // 滚动条
    var isShowScrollLine: Bool = false
    // 滚动条高度
    var scrollLineHeight: CGFloat = 3.0
    // 滚动条颜色
    var scrollLineColor: UIColor = .orange
    // 透明度
    var coverAlpha: CGFloat = 1.0
    
}
