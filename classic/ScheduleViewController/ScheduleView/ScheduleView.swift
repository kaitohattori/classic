//
//  ScheduleView.swift
//  classic
//
//  Created by kaichan on 6/7/18.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class ScheduleView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak private var scheduleCollectionView: UICollectionView!
    private var scheduleDetilesView: ScheduleDetilesView!
    
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
        let view = Bundle.main.loadNibNamed("ScheduleView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
        view.autoLayout(to: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let scheduleNib = UINib(nibName: "ScheduleCollectionViewCell", bundle: nil)
        let changeNib = UINib(nibName: "ScheduleCollectionViewChangedCell", bundle: nil)
        let numberNib = UINib(nibName: "ScheduleNumberCollectionViewCell", bundle: nil)
        scheduleCollectionView.register(scheduleNib, forCellWithReuseIdentifier: "scheduleCell")
        scheduleCollectionView.register(changeNib, forCellWithReuseIdentifier: "changeCell")
        scheduleCollectionView.register(numberNib, forCellWithReuseIdentifier: "numberCell")
        scheduleCollectionView.delegate = self
        scheduleCollectionView.dataSource = self
        
        
        scheduleDetilesView = ScheduleDetilesView(sender: self.parentViewController()!)
        scheduleDetilesView.hide(animation: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (5 + 1) * 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height = collectionView.frame.size.height / 8
        var width = (collectionView.frame.size.width - 25.0) / 5
        
        if indexPath.row % 6 == 0 {
            width = CGFloat(24.9)
        }
        
        // 小さすぎるデバイスの表示はセルを大きくして、スクロール表示に
        if width / height > 1.3 {
            height = width
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 時限
        if indexPath.row % 6 == 0 {
            let numberCell = collectionView.dequeueReusableCell(withReuseIdentifier: "numberCell", for: indexPath) as! ScheduleNumberCollectionViewCell
            
            numberCell.numberLabel.text = String(indexPath.row/6 + 1)
            
            return numberCell
        }
            // 授業
        else {
            
            let date = weekDates[indexPath.row % 6 - 1]
            let index = IndexPath(row: indexPath.row / 6, section: 1)
            if let changedClass = getChangedClass(date: date, indexPath: index) {
                
                let changeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "changeCell", for: indexPath) as! ScheduleCollectionViewChangedCell
                let className = changedClass[0]
                let classType = changedClass[1]
                
                changeCell.type = classType
                changeCell.name = className
                
                changeCell.setup()
                
                return changeCell
            }
            else {
                
                let scheduleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "scheduleCell", for: indexPath) as! ScheduleCollectionViewCell
                
                let col = indexPath.row % 6
                let row = indexPath.row / 6
                let name = weekNames[col - 1]
                let number = row + 1
                
                let className = scheduleManager.getClassName(weekName: name, classNumber: number)
                let color     = scheduleManager.getColor(weekName: name, classNumber: number)
                
                scheduleCell.name  = className
                scheduleCell.color = color
                if className == "" { scheduleCell.color = .white }
                
                scheduleCell.setup()
                
                return scheduleCell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row % 6 == 0 { return }
        
        let col = indexPath.row % 6
        let row = indexPath.row / 6
        let name = weekNames[col - 1]
        let number = row + 1
        
        let className = scheduleManager.getClassName(weekName: name, classNumber: number)
        let classRoom = scheduleManager.getClassRoom(weekName: name, classNumber: number)
        let color = scheduleManager.getColor(weekName: name, classNumber: number)
        
        if className == "" { return }
        
        scheduleDetilesView.show(weekName: name, classNumber: number, className: className, classRoom: classRoom, color: color)
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
    
    func reload() {
        scheduleCollectionView.reloadData()
    }
}
