//
//  SetScheduleViewColorSelectView.swift
//  classic
//
//  Created by kaichan on 2018/05/16.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class SetScheduleViewColorSelectView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var selectedColor: UIColor!
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    private let colors: [UIColor] = [.select_red,
                                     .select_orange,
                                     .select_yellow,
                                     .select_green,
                                     .select_blue,
                                     .select_purple,
                                     .select_gray,
                                     .select_black]
    
    init(sender: UIViewController) {
        super.init(frame: sender.view.frame)
        loadNib()
        sender.view.addSubview(self)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    private func loadNib(){
        let view = Bundle.main.loadNibNamed("SetScheduleViewColorSelectView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
        view.autoLayout(to: self)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let colorNib = UINib(nibName: "SetScheduleViewColorSelectViewCell", bundle: nil)
        colorCollectionView.register(colorNib, forCellWithReuseIdentifier: "colorCell")
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        setSelectedColor(color: .select_red)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! SetScheduleViewColorSelectViewCell
        
        colorCell.color = colors[indexPath.row]
        
        return colorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedColor = colors[indexPath.row]
        
        let cell: SetScheduleViewColorSelectViewCell = collectionView.cellForItem(at: indexPath) as! SetScheduleViewColorSelectViewCell
        cell.isSelected = true
    }
    
    /// 選択状態の色をセット
    func setSelectedColor(color: UIColor) {
        
        var num: Int = 0
        for i in 0 ..< colors.count {
            if color == colors[i] {
                num = i
                break
            }
        }
        
        // Select cell
        let indexPath = IndexPath(row: num, section: 0)
        self.colorCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        self.selectedColor = self.colors[indexPath.row]
    }
}

extension UIColor {
    static let select_red     = UIColor(red: 1.00, green: 0.35, blue: 0.20, alpha: 1.00)
    static let select_orange  = UIColor(red: 1.00, green: 0.60, blue: 0.20, alpha: 1.00)
    static let select_yellow  = UIColor(red: 1.00, green: 0.80, blue: 0.20, alpha: 1.00)
    static let select_green   = UIColor(red: 0.40, green: 0.85, blue: 0.20, alpha: 1.00)
    static let select_blue    = UIColor(red: 0.20, green: 0.60, blue: 1.00, alpha: 1.00)
    static let select_purple  = UIColor(red: 0.80, green: 0.20, blue: 1.00, alpha: 1.00)
    static let select_gray    = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.00)
    static let select_black   = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
}
