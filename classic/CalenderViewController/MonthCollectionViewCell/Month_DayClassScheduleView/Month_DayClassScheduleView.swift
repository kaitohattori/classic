//
//  Month_DayClassScheduleView.swift
//  classic
//
//  Created by kaichan on 2018/05/20.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class Month_DayClassScheduleView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var selectedDayIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var viewSize: CGSize = .zero
    
    @IBOutlet weak private var dayClassScheduleCollectionView: UICollectionView!
    
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
        let view = Bundle.main.loadNibNamed("Month_DayClassScheduleView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
        view.autoLayout(to: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let infoCell = UINib(nibName: "Month_DayClassScheduleViewCell", bundle: nil)
        let changeCell = UINib(nibName: "Month_DayClassScheduleViewChengedCell", bundle: nil)
        dayClassScheduleCollectionView.register(infoCell, forCellWithReuseIdentifier: "infoCell")
        dayClassScheduleCollectionView.register(changeCell, forCellWithReuseIdentifier: "changeCell")
        dayClassScheduleCollectionView.delegate   = self
        dayClassScheduleCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        var width  = collectionView.frame.size.width / 8
        if viewSize != .zero {
            width  = viewSize.width / 8
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let number = indexPath.row + 1
        
        let date = dateManager.conversionDateFormat(indexPath: selectedDayIndexPath)
        if let changedClass = getChangedClass(date: date, indexPath: indexPath) {
            
            let changeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "changeCell", for: indexPath) as! Month_DayClassScheduleViewChengedCell
            let className = changedClass[0]
            let classType = changedClass[1]
            
            changeCell.type   = classType
            changeCell.name   = className
            changeCell.number = String(number)
            
            changeCell.setup()
            
            return changeCell
        }
        else {
            
            let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "infoCell", for: indexPath) as! Month_DayClassScheduleViewCell
            
            let name   = dateManager.conversionWeekNameFormat(indexPath: selectedDayIndexPath)
            
            var className = ""
            var color     = UIColor.white
            if name != "Sun" && name != "Sat" {
                className = scheduleManager.getClassName(weekName: name, classNumber: number)
                color     = scheduleManager.getColor(weekName: name, classNumber: number)
            }
            
            infoCell.name   = className
            infoCell.number = String(number)
            infoCell.color  = color
            if className == "" { infoCell.color = .white }
            
            infoCell.setup()
            
            return infoCell
        }
    }
    
    private func getChangedClass(date: Date, indexPath: IndexPath) -> [String]? {
        
        if let classInfoDataArray = classInfoData[date] {
            for row in 0 ..< classInfoDataArray.count {
                let classNumber = classInfoDataArray[row].classNumber
                if classNumber == String(indexPath.row + 1) {
                    return [classInfoDataArray[row].className, classInfoDataArray[row].classType]
                }
            }
        }
        return nil
    }
    
    func reloadData(indexPath: IndexPath = IndexPath(row: -1, section: -1)) {
        if indexPath.row != -1 {
            selectedDayIndexPath = indexPath
        }
        dayClassScheduleCollectionView.reloadData()
    }
}
