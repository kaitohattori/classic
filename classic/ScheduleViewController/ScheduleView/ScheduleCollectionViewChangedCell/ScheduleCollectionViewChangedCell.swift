//
//  ScheduleCollectionViewChangedCell.swift
//  classic
//
//  Created by kaichan on 2018/05/21.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class ScheduleCollectionViewChangedCell: UICollectionViewCell {
    
    var name: String!
    var type: String!
    
    @IBOutlet weak private var colorView: UIView!
    @IBOutlet weak private var classTypeLabel: UILabel!
    @IBOutlet weak private var classNameLabel: UILabel!
    
    func setup() {
        colorView.layer.cornerRadius = 5
        colorView.layer.masksToBounds = true
        
        let stypeRed = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        colorView.backgroundColor   = stypeRed
        colorView.layer.borderColor = stypeRed.cgColor
        colorView.layer.borderWidth = 1
        
        classTypeLabel.layer.cornerRadius = 5
        classTypeLabel.layer.masksToBounds = true
        
        classTypeLabel.text = type
        classNameLabel.text = name
        
        if type == "休講" {
            colorView.backgroundColor   = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
            colorView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
}
