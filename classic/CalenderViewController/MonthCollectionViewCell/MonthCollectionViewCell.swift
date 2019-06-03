//
//  CalenderCollectionView.swift
//  classic
//
//  Created by kaichan on 2018/04/16.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

var classInfoData: [Date:[ClassData]] = [:]

class MonthCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayCollectionView: UICollectionView!
    @IBOutlet weak var dayClassScheduleView: Month_DayClassScheduleView!
    
    var year: Int!
    var month: Int!
    var viewSize: CGSize = .zero
    
    private let weekName = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    private var selectedDayIndexPath: IndexPath = IndexPath(row: 0, section: 1)
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let dayNib = UINib(nibName: "DayCollectionViewCell", bundle: nil)
        let dotwNib = UINib(nibName: "DayoftheweekCollectionViewCell", bundle: nil)
        dayCollectionView.register(dayNib, forCellWithReuseIdentifier: "dayCell")
        dayCollectionView.register(dotwNib, forCellWithReuseIdentifier: "dotwCell")
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
    }
    
    @IBAction func showThisMonthClicked(_ sender: Any) {
        let monthCV = self.superview as! UICollectionView
        let calenderVC = monthCV.parentViewController() as! CalenderViewController
        calenderVC.showThisMonth()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        } else {
            return 7 * 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width  = collectionView.frame.size.width / 7
        var height = collectionView.frame.size.height / 7
        if viewSize != .zero {
            width  = viewSize.width / 7
            height = viewSize.height / 7
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        
        // 曜日
        if indexPath.section == 0 {
            let dotwCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dotwCell", for: indexPath) as! DayoftheweekCollectionViewCell
            
            dotwCell.dotwLabel.text = weekName[row]
            
            return dotwCell
        }
        
        // 日付
        if indexPath.section == 1 {
            let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCollectionViewCell
            
            let todayDay = dateManager.conversionDayFormat(indexPath: indexPath)
            
            // テキストカラー
            dayCell.dayLabel.textColor = .black
            if (row/7 == 0 && Int(todayDay)! > 7)  { dayCell.dayLabel.textColor = .lightGray }
            if (row/7 >= 4 && Int(todayDay)! < 20) { dayCell.dayLabel.textColor = .lightGray }
            
            // 日付表示
            dayCell.dayLabel.text = todayDay
            
            // 選択円
            dayCell.selectedCircleView.backgroundColor = .clear
            dayCell.dayLabel.backgroundColor = .white
            if selectedDayIndexPath.row == indexPath.row {
                dayCell.selectedCircleView.backgroundColor = UIColor.groupTableViewBackground
                dayCell.dayLabel.backgroundColor = UIColor.clear
                dayCell.selectedAnimation()
            }
            
            // 授業変更の数
            let date = dateManager.conversionDateFormat(indexPath: indexPath)
            var count = 0
            if let classInfoDataArray = classInfoData[date] {
                count = classInfoDataArray.count
            }
            dayCell.markCount = count
            
            // 授業変更のType
            if let classInfoDataArray = classInfoData[date] {
                dayCell.markColor = []
                for classInfoDataValue in classInfoDataArray {
                    let type = classInfoDataValue.classType
                    let color = classTypeColor[type] ?? .gray
                    dayCell.markColor.append(color)
                }
            }
            
            // リロード
            dayCell.classMarkCollectionView.reloadData()
            
            return dayCell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            selectedDayIndexPath = indexPath
            
            // collectionView reload
            dayCollectionView.reloadData()
            
            // class schedule reload
            dayClassScheduleView.reloadData(indexPath: selectedDayIndexPath)
            
            // Taptic Engine
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
}

/*
 timer_1.setup(label: "timer_1", indexPath: indexPath, finalCellRow: 41)
 timer_1.start()
 timer_1.stop()
 */
var timer_1 = ProcessingTimeMeasurement()
class ProcessingTimeMeasurement: NSObject {
    
    var timerLabel: String = ""
    var startDate: Date! = nil
    var lapTime: Double = 0.0
    var counter: Int = 0
    var cellCount: Int = 0
    func setup(label: String, indexPath: IndexPath = IndexPath(row: 0, section: 0), finalCellRow: Int) {
        if indexPath.row == 0 {
            timerLabel = label
            cellCount = finalCellRow
            counter = 0
            lapTime = 0.0
        }
    }
    func start() {
        counter += 1
        startDate = Date()
    }
    func stop() {
        lapTime = Date().timeIntervalSince(startDate) + lapTime
        if cellCount == counter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.positiveFormat = "0.00000" // "0.##" -> 0パディングしない
            formatter.roundingMode = .halfUp // 四捨五入 // .floor -> 切り捨て
            let str:String = formatter.string(from: NSNumber(value: lapTime))!
            print(timerLabel); print(str)
        }
    }
}

extension UIView {
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            parentResponder = nextResponder
        }
    }
}
