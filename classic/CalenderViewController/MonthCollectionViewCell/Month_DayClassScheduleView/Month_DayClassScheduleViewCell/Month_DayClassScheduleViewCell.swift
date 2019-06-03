//
//  Month_DayClassScheduleViewCell.swift
//  classic
//
//  Created by kaichan on 2018/05/20.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class Month_DayClassScheduleViewCell: UICollectionViewCell {
    
    var name: String!
    var number: String!
    var color: UIColor!
    
    @IBOutlet weak private var colorView: UIView!
    @IBOutlet weak private var classNumberLabel: UILabel!
    @IBOutlet weak private var classNameLabel: UILabel!
    
    func setup() {
        colorView.layer.cornerRadius = 5
        
        colorView.backgroundColor   = color
        colorView.layer.borderColor = color.cgColor
        colorView.layer.borderWidth = 1
        if color == .white { colorView.layer.borderColor = UIColor.groupTableViewBackground.cgColor }
        
        classNumberLabel.text = number
        classNameLabel.text = name
    }
}
