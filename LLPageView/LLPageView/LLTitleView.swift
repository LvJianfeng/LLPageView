//
//  LLTitleView.swift
//  LLPageView
//
//  Created by LvJianfeng on 2017/11/30.
//  Copyright © 2017年 LvJianfeng. All rights reserved.
//

import UIKit

protocol LLTitleViewDelegate: class {
    func titleView(_ pageView: LLTitleView, targetIndex: Int)
}

class LLTitleView: UIView {
    
    // Delegate
    weak var delegate: LLTitleViewDelegate?
    
    fileprivate var titles: [String]
    fileprivate var style: LLTitleStyle
    fileprivate lazy var currentIndex: Int = 0
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    
    fileprivate lazy var scrollView: UIScrollView  = {
        let scrollView = UIScrollView.init(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.scrollLineColor
        bottomLine.frame.size.height = self.style.scrollLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.scrollLineHeight
        return bottomLine
    }()
    
    

    init(frame: CGRect, titles: [String], style: LLTitleStyle = LLTitleStyle()) {
        
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LLTitleView {
    fileprivate func setupUI() {
        addSubview(scrollView)
        
        setupTitleLabels()
        
        setupTitleLabelFrame()
        
        // BottomLine
        if style.isShowScrollLine {
            scrollView.addSubview(bottomLine)
        }
    }
    
    private func setupTitleLabels() {
        for (i, title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = style.font
            titleLabel.textAlignment = .center
            titleLabel.tag = i
            titleLabel.textColor = i==0 ? style.selectedColor : style.normalColor
            
            scrollView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
            
            titleLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapTitleAction(_:))))
            titleLabel.isUserInteractionEnabled = true
        }
    }
    
    private func setupTitleLabelFrame() {
        let count = titles.count
        
        for (i, label) in titleLabels.enumerated() {
            var w: CGFloat = 0
            var x: CGFloat = 0
            
            // 判断是否允许滚动
            if style.isScrollEnable {
                w = (titles[i] as NSString).boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: label.font], context: nil).width
                if i==0 {
                    x = style.itemMargin * 0.5
                    
                    if style.isShowScrollLine {
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width = w
                    }
                    
                }else{
                    x = titleLabels[i-1].frame.maxX + style.itemMargin
                }
                
                
            }else{
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
                
                if i == 0 && style.isShowScrollLine{
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                }
            }
            
            label.frame = CGRect.init(x: x, y: 0, width: w, height: bounds.height)
        }
        scrollView.contentSize = style.isScrollEnable ? CGSize.init(width: titleLabels.last!.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
    }
}

// MARK:- 监听点击事件
extension LLTitleView {
    @objc fileprivate func tapTitleAction(_ tap: UITapGestureRecognizer) {
        guard let targetLabel = tap.view as? UILabel else {
            return
        }
        let sourceLabel = titleLabels[currentIndex]
        
        if targetLabel == sourceLabel {
            return
        }
        // 调整title
        adjustTitleLabel(targetIndex: targetLabel.tag)
        
        // 调整bottomLine
        if style.isShowScrollLine {
            UIView.animate(withDuration: 0.25) {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.size.width
            }
        }
        
        // delegate
        delegate?.titleView(self, targetIndex: currentIndex)
        
    }
    
    private func adjustTitleLabel(targetIndex: Int) {
        let currentLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        // 恢复所有的label
        for label in scrollView.subviews {
            if label is UILabel, label != currentLabel {
                (label as! UILabel).textColor = style.normalColor
            }
        }
        // 切换颜色
        // 快速切换问题 sourceLabel.textColor = style.normalColor
        currentLabel.textColor = style.selectedColor
        
        currentIndex = targetIndex
        
        // 控制滚动位置
        if style.isScrollEnable {
            var offsetX = currentLabel.center.x - scrollView.bounds.width * 0.5
            if offsetX < 0 {
                offsetX = 0
            }
            
            if offsetX > scrollView.contentSize.width - scrollView.bounds.width {
                offsetX = scrollView.contentSize.width - scrollView.bounds.width
            }
            scrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
        }
    }
}

// MARK:- ContrainerDelagete
extension LLTitleView: LLContrainerViewDelegate {
    func contrainerView(_ contrainerView: LLContrainerView, targetIndex: Int) {
        adjustTitleLabel(targetIndex: targetIndex)
    }
    
    func contrainerView(_ contrainerView: LLContrainerView, targetIndex: Int, progress: CGFloat) {
        let currentLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        // 颜色渐变
        let deltaRGB = UIColor.getRGBDelta(style.selectedColor, style.normalColor)
        let selectedRGB = style.selectedColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        
        currentLabel.textColor = UIColor.init(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor.init(r: selectedRGB.0 - deltaRGB.0 * progress, g: selectedRGB.1 - deltaRGB.1 * progress, b: selectedRGB.2 - deltaRGB.2 * progress)
        
        if style.isShowScrollLine {
            let deltaX = currentLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = currentLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
        }
    }
}

