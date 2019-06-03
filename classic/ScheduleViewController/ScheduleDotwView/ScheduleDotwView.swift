//
//  ScheduleDotwView.swift
//  classic
//
//  Created by kaichan on 6/7/18.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class ScheduleDotwView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak private var scheduleDotwCollectionView: UICollectionView!
    private let weekNames = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    var weekDays: [String] = []
    var weekDates: [Date]  = []
    
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
        let view = Bundle.main.loadNibNamed("ScheduleDotwView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
        view.autoLayout(to: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let dotwNib = UINib(nibName: "ScheduleDotwCollectionViewCell", bundle: nil)
        scheduleDotwCollectionView.register(dotwNib, forCellWithReuseIdentifier: "dotwCell")
        scheduleDotwCollectionView.delegate   = self
        scheduleDotwCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.height
        var width = (collectionView.frame.size.width - 25.0) / 5
        
        if indexPath.row == 0 {
            width = CGFloat(24.9)
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dotwCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dotwCell", for: indexPath) as! ScheduleDotwCollectionViewCell
        
        if indexPath.row == 0 {
            dotwCell.dayLabel.text  = ""
            dotwCell.dotwLabel.text = ""
        }
        else {
            dotwCell.dayLabel.text  = weekDays[indexPath.row-1]
            dotwCell.dotwLabel.text = weekNames[indexPath.row-1]
        }
        
        return dotwCell
    }
    
    func reload() {
        scheduleDotwCollectionView.reloadData()
    }
}
