//
//  LLContrainerView.swift
//  LLPageView
//
//  Created by LvJianfeng on 2017/11/30.
//  Copyright © 2017年 LvJianfeng. All rights reserved.
//

import UIKit 

protocol LLContrainerViewDelegate: class {
    func contrainerView(_ contrainerView: LLContrainerView, targetIndex: Int)
    func contrainerView(_ contrainerView: LLContrainerView, targetIndex: Int, progress: CGFloat)
}

class LLContrainerView: UIView {
    
    weak var delegate: LLContrainerViewDelegate?
    
    fileprivate var childViewControllers: [UIViewController]
    fileprivate var parsentViewController: UIViewController
    
    fileprivate var startOffsetX: CGFloat = 0.0
    // 是否禁止滚动
    fileprivate var isForbidScroll: Bool = false
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        // 禁止尽头的滚动效果
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "kContrainerViewCell")
        
        return collectionView
    }()

    init(frame: CGRect, childViewControllers: [UIViewController], parsentViewController: UIViewController) {
        
        self.childViewControllers = childViewControllers
        self.parsentViewController = parsentViewController
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LLContrainerView {
    fileprivate func setupUI() {
        for childViewController in childViewControllers {
            parsentViewController.addChildViewController(childViewController)
        }
        
        addSubview(collectionView)
    }
}

extension LLContrainerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kContrainerViewCell", for: indexPath)
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childViewController = childViewControllers[indexPath.row]
        childViewController.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childViewController.view)
        return cell
    }
}

// MARK:- ScrollView Delegate
extension LLContrainerView: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            contentEndScroll()
        }
    }
    
    private func contentEndScroll() {
        
        guard !isForbidScroll else {
            return
        }
        
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        // 修改TitleView的currentIndex
        delegate?.contrainerView(self, targetIndex: currentIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScroll = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard startOffsetX != scrollView.contentOffset.x, !isForbidScroll else {
            return
        }
        
        // target / progress
        var targetIndex = 0
        var progress: CGFloat = 0.0
        
        let currentIndex = Int(startOffsetX / scrollView.bounds.width)
        if startOffsetX < scrollView.contentOffset.x {
            // 左滑
            targetIndex = currentIndex+1
            if targetIndex > childViewControllers.count-1 {
                targetIndex = childViewControllers.count-1
            }
            
            progress = (scrollView.contentOffset.x - startOffsetX) / scrollView.bounds.width
        }else{
            // 右滑
            targetIndex = currentIndex-1
            if targetIndex < 0 {
                targetIndex = 0
            }
            
            progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width
        }
        
        delegate?.contrainerView(self, targetIndex: targetIndex, progress: progress)
    }
}

// MARK:- TitleView Delegate
extension LLContrainerView: LLTitleViewDelegate {
    func titleView(_ pageView: LLTitleView, targetIndex: Int) {
        
        isForbidScroll = true
        
        let indexPath = IndexPath.init(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}



