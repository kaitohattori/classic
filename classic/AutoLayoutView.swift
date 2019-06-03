//
//  AutoLayoutView.swift
//  classic
//
//  Created by kaichan on 2018/05/23.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Viewいっぱいにオートレイアウト
    func autoLayout(to toView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: toView.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: toView.rightAnchor).isActive = true
    }
}
