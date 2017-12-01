//
//  ViewController.swift
//  LLPageView
//
//  Created by LvJianfeng on 2017/11/30.
//  Copyright © 2017年 LvJianfeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let style = LLTitleStyle()
        style.scrollLineColor = UIColor.black
        
        let titles = ["热门", "明星娱乐", "游戏攻略", "产品", "大吉大利", "光荣使命", "终结者", "军事", "直播"]
        
        var childVCs = [UIViewController]()
        
        for _ in 0..<titles.count {
            let vc = UIViewController()
            
            vc.view.backgroundColor = UIColor.init(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
            childVCs.append(vc)
        }
        
        let pageFrame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        let pageView = LLPageView.init(frame: pageFrame, titles: titles, childViewControllers: childVCs, parsentViewController: self, style: style)
        view.addSubview(pageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

