//
//  PageContentView.swift
//  DYZB
//
//  Created by yjcfxg on 2017/7/4.
//  Copyright © 2017年 yjcfxg. All rights reserved.
//

import UIKit
protocol PageContentViewDelegate : class {
    func pageContentView(contentView : PageContentView , progress :CGFloat , sourceIndex : Int ,targetIndex : Int)
}
private let collectId = "hjfjldf"
class PageContentView: UIView {

    //自定属性
    var childVcs :[UIViewController]
    var parentViewController :UIViewController?
    var startOffsetX : CGFloat = 0
    var isForbidScrollDelegate : Bool = false
    weak var delegate : PageContentViewDelegate?
    //懒加载属性,闭包中的self避免循环引用
    lazy var collectionView : UICollectionView = { [weak self] in
        //1.创建layout
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //2.创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectId)
        return collectionView
        
    }()
    
    //自定义构造函数
    init(frame: CGRect ,childVcs :[UIViewController] , parentViewController :UIViewController?) {
        
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        
        // 设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension PageContentView {
    func setupUI()  {
        //1. 将所有的子控制器添加到父控制器里
        for chileVc in childVcs {
            parentViewController?.addChildViewController(chileVc)
        }
        //2.添加UICollectionView，用于在cell中存放控制器的view
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}
extension PageContentView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectId, for: indexPath)
        //2.给cell设置内容
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        
        return cell
    }
}

extension PageContentView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //0.判断是否是点击事件
        if isForbidScrollDelegate {
            return
        }
        //1.获取需要的数据
        var progress :CGFloat = 0
        var sourceIndex :Int = 0
        var targetIndex :Int = 0
        
        //2.判断左滑还是有滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        
        if currentOffsetX > startOffsetX {//左滑
            //1. 计算progress
            progress = currentOffsetX/scrollViewW - floor(currentOffsetX / scrollViewW)
            //2.
            sourceIndex = Int(currentOffsetX / scrollViewW)
            //3.
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            //4.如果完全滑过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        }else {//右滑
            //2.计算progress
            progress = 1 - (currentOffsetX/scrollViewW - floor(currentOffsetX / scrollViewW))
            //2.计算target
            targetIndex = Int(currentOffsetX / scrollViewW)
            //3.
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
        // 3.将progress/sourceIndex/targetIndex传递给TitleView
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
//mark 对外暴露的方法
extension PageContentView {
    func setCurrentIndex(_ currentIndex :Int) {
        //1.记录需要进行执代理方法
        isForbidScrollDelegate = true
         //2.滚动到正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
        
    }
}
