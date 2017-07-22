//
//  RecommendViewController.swift
//  DYZB
//
//  Created by yjcfxg on 2017/7/14.
//  Copyright © 2017年 yjcfxg. All rights reserved.
//

import UIKit
private let kItemMargin :CGFloat = 10
private let kItemW = (kScreenW - 3*kItemMargin)/2
private let kItemH = kItemW * 3/4
private let kNormalCellID = "hjdjh"
private let kHeaderViewID = "hjd"
private let kHeaderViewH :CGFloat = 50
class RecommendViewController: UIViewController {

    //mark 懒加载属性
    
    lazy var collectionView :UICollectionView = { [unowned self] in
        //1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
//        layout.sectionInset = UIEdgeInsetsMake(0, kItemMargin, 0, kItemMargin)
        //2. 创建UICollectionView
        
      let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        //自适应
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.register(UINib.init(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        
        collectionView.register(UINib.init(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        return collectionView
    }()
    //系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
       

        //设置UI界面
        setupUI()
        
    }

    
    
}
extension RecommendViewController {
    fileprivate func setupUI(){
        view.addSubview(collectionView)
        
    }
}

extension RecommendViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath)
        
    
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1,取出section的headerView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath)
        
        return headerView
    }
}
