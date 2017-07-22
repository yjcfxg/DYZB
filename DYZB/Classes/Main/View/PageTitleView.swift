//
//  PageTitleView.swift
//  DYZB
//
//  Created by yjcfxg on 2017/7/4.
//  Copyright © 2017年 yjcfxg. All rights reserved.
//

import UIKit
//mark 定义协议
protocol PageTitleViewDelegate : class {
    func pageTitleView(_ titleView: PageTitleView, selectIndex index: Int)
}
//mark 定义颜色
private let kNormalCol :(CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kselectCol :(CGFloat,CGFloat,CGFloat) = (255,128,0)
//mark 定义常量
private let scrollLineH :CGFloat = 2.0
//mark 定义类
class PageTitleView: UIView {

    //mark -定义属性
    var currentIndex : Int = 0
    
    var titles :[String]
    
    
    weak var delegate : PageTitleViewDelegate?
    //mark 懒加载UIScrollView
   lazy var titleLabels :[UILabel] = [UILabel]()
    lazy var scrollView :UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        return scrollView
    }()
    
     lazy var scrollLine :UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    //mark -自定义构造函数
    init(frame: CGRect , titles :[String]) {
        self.titles = titles
        super.init(frame: frame)
        //设置ui界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageTitleView {
     func setupUI(){
        //1.添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        //2.添加title对应的label
        setupTitleLabels()
        //3. 设置底线和滚动滑块
        setupBottommenuAndScrollLine()
        
    }
    private func setupTitleLabels(){
        let labelW :CGFloat = frame.width / CGFloat(titles.count)
        let labelH :CGFloat = frame.height - scrollLineH
        let labelY :CGFloat = 0.0
        for (index, title) in titles.enumerated() {
           //1.创建label
            let label = UILabel()
            //2.给label设置属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalCol.0, g: kNormalCol.1, b: kNormalCol.2)
            label.textAlignment = .center
            //3.设置label的frame
            let labelX :CGFloat = labelW * CGFloat(index)
            
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            //4.将label添加到scrollview
            scrollView.addSubview(label)
            titleLabels.append(label)
            //5.给label添加手势
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tap:)))
            label.addGestureRecognizer(tap)
            
        }
    }
    private func setupBottommenuAndScrollLine(){
        //1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.white
        let lineH :CGFloat = 0.5
        
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: scrollLineH)
        addSubview(bottomLine)
        
        //2. 添加scrollLine
        //2.1获取第一个label
        guard let firstLabel = titleLabels.first else { return }
        
        //2.2设置scrollView的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - scrollLineH, width: firstLabel.frame.width, height: scrollLineH)
    }
}
//监听label的点击
extension PageTitleView {
  @objc func titleLabelClick(tap :UITapGestureRecognizer) {
        //1.获取当前的lable
    guard let currentLabel = tap.view as? UILabel else {return}
    //2.获取之前的label
    let oldLabel = titleLabels[currentIndex]
    //3.切换文字的颜色
    currentLabel.textColor = UIColor(r: kselectCol.0, g: kselectCol.1, b: kselectCol.2)
    oldLabel.textColor = UIColor(r: kNormalCol.0, g: kNormalCol.1, b: kNormalCol.2)
    //4.保存最新的label下标值
    currentIndex = currentLabel.tag
    //5.滚动条位置发生改变
    let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
    UIView.animate(withDuration: 0.1) { 
        self.scrollLine.frame.origin.x = scrollLineX
    }
    //6.通知代理
    delegate?.pageTitleView(self, selectIndex: currentIndex)
    }
}
//mark 对外暴露的犯法
extension PageTitleView {
    func setTitleWithProgress(progress : CGFloat,sourceIndex :Int,targetIndex :Int) {
        
        //1.取出sourceLabel和targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        //2.处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        //3.颜色的渐变
        //3.1取出变化的颜色范围
        let colorDelta = (kselectCol.0 - kNormalCol.0,kselectCol.1 - kNormalCol.1,kselectCol.2 - kNormalCol.2)
        //3.2变化sourceLabel
        sourceLabel.textColor = UIColor(r: kselectCol.0 - colorDelta.0 * progress, g: kselectCol.1 - colorDelta.1 * progress, b: kselectCol.2 - colorDelta.2 * progress)
        //3.3变化的targetLabel
        targetLabel.textColor = UIColor(r: kNormalCol.0 + colorDelta.0 * progress, g: kNormalCol.1 + colorDelta.1 * progress, b: kNormalCol.2 + colorDelta.2 * progress)
        //4.记录最新的index
        currentIndex = targetIndex
        
        
    }
}
