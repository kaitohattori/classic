//
//  DayCollectionViewCell.swift
//  classic
//
//  Created by kaichan on 2018/04/16.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var selectedCircleView: UIView!
    @IBOutlet weak var classMarkCollectionView: UICollectionView!
    
    var markCount: Int = 0
    var markColor: [UIColor] = []
    
    private var markOverFlag: Bool = false
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let markNib = UINib(nibName: "ClassMarkCollectionViewCell", bundle: nil)
        let markOverNib = UINib(nibName: "ClassMarkOverCollectionViewCell", bundle: nil)
        classMarkCollectionView.register(markNib, forCellWithReuseIdentifier: "markCell")
        classMarkCollectionView.register(markOverNib, forCellWithReuseIdentifier: "markOverCell")
        classMarkCollectionView.delegate = self
        classMarkCollectionView.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            
            // selectedCircleViewを丸に
            self.selectedCircleView.layer.cornerRadius = self.selectedCircleView.frame.size.width/2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = markCount
        if markCount > 3 {
            markOverFlag = true
            count = 2
        }
        else {
            markOverFlag = false
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if !markOverFlag || indexPath.row == 0 {
            let markCell = classMarkCollectionView.dequeueReusableCell(withReuseIdentifier: "markCell", for: indexPath) as! ClassMarkCollectionViewCell
            
            markCell.setMarkColor(color: markColor[indexPath.row])
            return markCell
        }
        else {
            let markOverCell = classMarkCollectionView.dequeueReusableCell(withReuseIdentifier: "markOverCell", for: indexPath) as! ClassMarkOverCollectionViewCell
            
            markOverCell.classMarkOverLabel.text = "×" + String(markCount)
            return markOverCell
        }
    }
    
    // セルのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 20.0
        var width: CGFloat  = 10.0
        if markOverFlag && indexPath.row != 0 {
            width  = 20.0
        }
        return CGSize(width: width, height: height)
    }
    
    /// セルの左右スペース
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var count:CGFloat = CGFloat(markCount)
        var size:CGFloat  = 10.0
        if markOverFlag { count = 2; size = 15.0}
        // マークをcollectionviewの中心に表示
        let width = classMarkCollectionView.frame.size.width
        let space = (width - size*count)/2
        return UIEdgeInsets(top: 0.0, left: space, bottom: 0.0, right: space)
    }
    
    func selectedAnimation() {
        // アニメーション
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
            self.selectedCircleView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                self.selectedCircleView.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            }) { _ in
                UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                    self.selectedCircleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }
        }
    }
}
