//
//  SetScheduleCollectionViewCell.swift
//  classic
//
//  Created by kaichan on 2018/05/13.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

protocol SetScheduleCollectionViewCellDelegate: class {
    func menuRemoveClicked(collectionView: UICollectionView, indexPath: IndexPath)
}

class SetScheduleCollectionViewCell: UICollectionViewCell {
    
    var delegate: SetScheduleCollectionViewCellDelegate!
    var color: UIColor = UIColor.groupTableViewBackground
    var isSet: Bool = false
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var addImageView: UIImageView!
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                colorView.backgroundColor = color.dark()
            }
            else {
                colorView.backgroundColor = color
            }
        }
    }
    
    func setup() {
        colorView.layer.cornerRadius = 5
        
        if isSet {
            addImageView.isHidden   = true
            classNameLabel.isHidden = false
            
            colorView.backgroundColor   = color
            colorView.layer.borderColor = color.cgColor
            colorView.layer.borderWidth = 1
        }
        else {
            addImageView.isHidden   = false
            classNameLabel.isHidden = true
            
            colorView.backgroundColor   = color
            colorView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            colorView.layer.borderWidth = 1
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(remove(_:))
    }
    @objc func remove(_ sender: Any?) {
        
        if let collectionView = self.superview as? UICollectionView {
            if let indexPath = collectionView.indexPath(for: self) {
                if delegate != nil { delegate.menuRemoveClicked(collectionView: collectionView, indexPath: indexPath) }
            }
        }
    }
    
    func selectedAnimation() {
        // アニメーション
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
            self.colorView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                self.colorView.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            }) { _ in
                UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                    self.colorView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }
        }
    }
}

extension UIColor {
    /// 色を若干濃くする
    public func dark() -> UIColor {
        let ratio: CGFloat = 0.9
        
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness * ratio, alpha: alpha)
    }
}
