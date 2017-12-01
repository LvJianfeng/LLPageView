//
//  LLPageView.swift
//  LLPageView
//
//  Created by LvJianfeng on 2017/11/30.
//  Copyright © 2017年 LvJianfeng. All rights reserved.
//

import UIKit

class LLPageView: UIView {
    
    // 标题
    fileprivate var titles: [String]
    // 子控制器集合
    fileprivate var childViewControllers: [UIViewController]
    // 父控制器
    fileprivate var parsentViewController: UIViewController
    // Title Style
    fileprivate var style: LLTitleStyle
    // Title View
    fileprivate var titleView: LLTitleView!

    
    // Init
    init(frame: CGRect, titles: [String], childViewControllers: [UIViewController], parsentViewController: UIViewController, style: LLTitleStyle = LLTitleStyle()) {
        
        self.titles = titles
        self.childViewControllers = childViewControllers
        self.parsentViewController = parsentViewController
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LLPageView {
    
    fileprivate func setupUI() {
        setupTitleView()
        setupContrainerView()
    }
    
    private func setupTitleView() {
        let titleFrame = CGRect.init(x: 0, y: style.topMargin, width: bounds.width, height: style.titleHeight)
        titleView = LLTitleView.init(frame: titleFrame, titles: titles, style: style)
        addSubview(titleView)
    }
    
    private func setupContrainerView() {
        let contrainerFrame = CGRect.init(x: 0, y: titleView.frame.maxY, width: bounds.width, height: bounds.height - titleView.frame.maxY)
        
        let contrainerView = LLContrainerView.init(frame: contrainerFrame, childViewControllers: childViewControllers, parsentViewController: parsentViewController)
        addSubview(contrainerView) 
        
        // delegate
        titleView.delegate = contrainerView
        contrainerView.delegate = titleView
    }
}
