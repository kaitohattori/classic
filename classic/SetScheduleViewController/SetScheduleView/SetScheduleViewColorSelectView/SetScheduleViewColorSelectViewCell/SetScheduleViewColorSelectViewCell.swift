//
//  SetScheduleViewColorSelectViewCell.swift
//  classic
//
//  Created by kaichan on 2018/05/16.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class SetScheduleViewColorSelectViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var selectedBorderView: UIView!
    @IBOutlet weak private var colorView: UIView!
    var color: UIColor!
    
    override var isSelected: Bool {
        didSet {
            selectedBorderView.isHidden = !isSelected
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        selectedBorderView.layer.cornerRadius = selectedBorderView.frame.size.width / 2
        selectedBorderView.layer.borderColor = color.cgColor
        selectedBorderView.layer.borderWidth = 1
        selectedBorderView.isHidden = true
        
        colorView.layer.cornerRadius = colorView.frame.size.width / 2
        colorView.backgroundColor = color
    }
}
