//
//  SetScheduleViewController.swift
//  classic
//
//  Created by kaichan on 2018/05/13.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class SetScheduleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SetScheduleCollectionViewCellDelegate, SetScheduleViewDelegate, ScheduleManagerDelegate {
    
    @IBOutlet weak var setscheduleCollectionView: UICollectionView!
    var setScheduleView: SetScheduleView!
    var recieveScheduleView: RecieveScheduleView!
    
    private let weekNames = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    private var selectedIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScheduleView = SetScheduleView(sender: self)
        setScheduleView.hide(animation: false)
        setScheduleView.delegate = self
        
        recieveScheduleView = RecieveScheduleView(sender: self)
        recieveScheduleView.hide(animation: false)
        
        let scheduleNib = UINib(nibName: "SetScheduleCollectionViewCell", bundle: nil)
        let dotwNib = UINib(nibName: "SetScheduleDayoftheweekCollectionViewCell", bundle: nil)
        let numberNib = UINib(nibName: "SetScheduleNumberCollectionViewCell", bundle: nil)
        setscheduleCollectionView.register(scheduleNib, forCellWithReuseIdentifier: "scheduleCell")
        setscheduleCollectionView.register(dotwNib, forCellWithReuseIdentifier: "dotwCell")
        setscheduleCollectionView.register(numberNib, forCellWithReuseIdentifier: "numberCell")
        setscheduleCollectionView.delegate = self
        setscheduleCollectionView.dataSource = self
        
        let menu = UIMenuItem(title: "remove", action: #selector(remove(_:)))
        UIMenuController.shared.arrowDirection = UIMenuControllerArrowDirection.down
        UIMenuController.shared.menuItems = [menu]
        UIMenuController.shared.setTargetRect(CGRect.zero, in: self.view)
        UIMenuController.shared.isMenuVisible = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scheduleManager = ScheduleManager()
        scheduleManager.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func recieveClicked(_ sender: Any) {
        recieveScheduleView.show()
    }
    
    @IBAction func completeClicked(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "isSetSchedule")
        
        // 画面遷移
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if indexPath.section == 0 || indexPath.row % 6 == 0 { return }
        
        let cell = collectionView.cellForItem(at: indexPath) as! SetScheduleCollectionViewCell
        cell.isHighlighted = true
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if indexPath.section == 0 || indexPath.row % 6 == 0 { return }
        
        let cell = collectionView.cellForItem(at: indexPath) as! SetScheduleCollectionViewCell
        cell.isHighlighted = false
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 5 + 1
        }
        else {
            return (5 + 1) * 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.height / 9
        var width = (collectionView.frame.size.width - 25.0) / 5
        
        if indexPath.row % 6 == 0 {
            width = CGFloat(24.9)
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 曜日
        if indexPath.section == 0 {
            let dotwCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dotwCell", for: indexPath) as! SetScheduleDayoftheweekCollectionViewCell
            
            if indexPath.row == 0 { dotwCell.dotwLabel.text = "" }
            else {                  dotwCell.dotwLabel.text = weekNames[indexPath.row-1] }
            
            return dotwCell
        }
        else {
            // 時限
            if indexPath.row % 6 == 0 {
                let numberCell = collectionView.dequeueReusableCell(withReuseIdentifier: "numberCell", for: indexPath) as! SetScheduleNumberCollectionViewCell
                
                numberCell.numberLabel.text = String(indexPath.row/6 + 1)
                
                return numberCell
            }
            // 授業
            else {
                let scheduleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "scheduleCell", for: indexPath) as! SetScheduleCollectionViewCell
                
                scheduleCell.delegate = self
                
                let col = indexPath.row % 6
                let row = indexPath.row / 6
                let name = weekNames[col - 1]
                let number = row + 1
                
                let className = scheduleManager.getClassName(weekName: name, classNumber: number)
                let color = scheduleManager.getColor(weekName: name, classNumber: number)
                
                if className == "" {
                    scheduleCell.isSet = false
                    scheduleCell.color = .white
                    scheduleCell.classNameLabel.text = className
                }
                else {
                    scheduleCell.isSet = true
                    scheduleCell.color = color
                    scheduleCell.classNameLabel.text = className
                }
                
                scheduleCell.setup()
                
                return scheduleCell
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 || indexPath.row % 6 == 0 { return }
        
        let col = indexPath.row % 6
        let row = indexPath.row / 6
        let name = weekNames[col - 1]
        let number = row + 1
        
        let className = scheduleManager.getClassName(weekName: name, classNumber: number)
        let classRoom = scheduleManager.getClassRoom(weekName: name, classNumber: number)
        let color = scheduleManager.getColor(weekName: name, classNumber: number)
        
        setScheduleView.show(weekName: name, classNumber: number, className: className, classRoom: classRoom, color: color)
        selectedIndexPath = indexPath
    }
    
    // MenuController ここから
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 || indexPath.row % 6 == 0 { return false }
        return true
    }
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) { }
    func menuRemoveClicked(collectionView: UICollectionView, indexPath: IndexPath) {
        
        let col = indexPath.row % 6
        let row = indexPath.row / 6
        let name = weekNames[col - 1]
        let number = row + 1
        
        scheduleManager.removeData(weekName: name, classNumber: number)
        
        setscheduleCollectionView.reloadItems(at: [indexPath])
    }
    @objc func remove(_ sender: Any?) { }
    // MenuController ここまで
    
    func setSchedule(weekName: String, classNumber: Int, className: String, classRoom: String, color: UIColor) {
        scheduleManager.set(weekName: weekName, classNumber: classNumber, className: className, classRoom: classRoom, color: color)
        
        // reload
        self.setscheduleCollectionView.reloadItems(at: [selectedIndexPath])
        
        // animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let cell: SetScheduleCollectionViewCell = self.setscheduleCollectionView.cellForItem(at: self.selectedIndexPath) as! SetScheduleCollectionViewCell
            cell.selectedAnimation()
        }
        
    }
    
    func recievedClassScheduleFromAirDrop() {
        scheduleManager = ScheduleManager()
        scheduleManager.delegate = self
        setscheduleCollectionView.reloadData()
    }
    
}
