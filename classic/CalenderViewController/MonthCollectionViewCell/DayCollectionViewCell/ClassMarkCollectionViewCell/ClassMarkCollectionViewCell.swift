//
//  ClassTableView.swift
//  classic
//
//  Created by kaichan on 2018/04/16.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class ClassMarkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var classMarkImageView: UIImageView!
    
    private let colorSets: [UIColor:UIImage] = [.gray       : UIImage(named: "ClassMarkCVC_mark_gray")!,
                                                .mainorange : UIImage(named: "ClassMarkCVC_mark_orange")!,
                                                .skyblue    : UIImage(named: "ClassMarkCVC_mark_skyblue")!]
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    func setMarkColor(color: UIColor) {
        classMarkImageView.image = colorSets[color]
    }
}
