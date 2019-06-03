//
//  SetScheduleCollectionViewCell.swift
//  classic
//
//  Created by kaichan on 2018/05/13.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class ScheduleCollectionViewCell: UICollectionViewCell {
    
    var name: String!
    var color: UIColor!
    
    @IBOutlet weak private var colorView: UIView!
    @IBOutlet weak private var classNameLabel: UILabel!
    
    func setup() {
        colorView.layer.cornerRadius = 5
        
        colorView.backgroundColor   = color
        colorView.layer.borderColor = color.cgColor
        colorView.layer.borderWidth = 1
        if color == .white { colorView.layer.borderColor = UIColor.groupTableViewBackground.cgColor }
        
        classNameLabel.text = name
    }
}
