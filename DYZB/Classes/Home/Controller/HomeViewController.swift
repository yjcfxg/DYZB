//
//  HomeViewController.swift
//  DYZB
//
//  Created by yjcfxg on 2017/7/3.
//  Copyright © 2017年 yjcfxg. All rights reserved.
//

import UIKit

private let kTitleViewH :CGFloat = 40
class HomeViewController: UIViewController {

    //mark 懒加载属性
     lazy var pageTitleView :PageTitleView = { [weak self] in
        let titleframe = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        
        let titles = ["推荐","游戏","娱乐","趣玩"]
        
        let titleView = PageTitleView(frame: titleframe, titles: titles)
        titleView.backgroundColor = UIColor.white
        titleView.delegate = self
        return titleView
    }()
    lazy var pageContentView :PageContentView = { [weak self] in
        //1. 确定内容的frame
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH - kTabbarH
        let contentframe = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        //2.确定所有的子控制器
        var childVcs = [UIViewController]()
        //子控制器添加进来
        childVcs.append(RecommendViewController())
        for _ in 0..<4 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        let contentView = PageContentView(frame: contentframe, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()
    //系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置Ui界面
        setupUI()
    }

    
}

//mark - 设置UI界面
extension HomeViewController {
     func setupUI(){
        //0.不需要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        //1.设置导航栏
        setupNavigationBar()
        //2. 添加titleView
        view.addSubview(pageTitleView)
        //3.添加ContentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.purple
    }
    private func setupNavigationBar(){
        //1.设置左侧的item
        let btn = UIButton()
        
        btn.setImage(UIImage(named: "logo"), for: UIControlState.normal)
        btn.sizeToFit()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        //2.设置右侧的item
        let size = CGSize(width: 40, height: 40)
        
        
//        let historyBtn = UIButton()
//        historyBtn.setImage(UIImage(named: "image_my_history"), for: .normal)
//        historyBtn.setImage(UIImage(named: "image_my_history_click"), for: .highlighted)
//        historyBtn.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_click", size: size)

        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)

//        let historyItem = UIBarButtonItem.createItem(imageName: "image_my_history", highImageName: "image_my_history_click", size: size)
//        
//        let searchItem = UIBarButtonItem.createItem(imageName: "btn_search", highImageName: "btn_search_click", size: size)
//        
//        let qrcodeItem = UIBarButtonItem.createItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
        
    }

}
// mark 遵守PageTitleViewDelegate协议
extension HomeViewController :PageTitleViewDelegate {
    func pageTitleView(_ titleView: PageTitleView, selectIndex index: Int) {
        pageContentView.setCurrentIndex(index)
    }
}
// mark 遵守PageContentViewDelegate协议
extension HomeViewController : PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress,sourceIndex:sourceIndex,targetIndex : targetIndex)
    }
    
}
