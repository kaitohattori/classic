//
//  ManagementCalenderViewController.swift
//  classic
//
//  Created by kaichan on 2018/04/16.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

let dateManager = DateManager()
let getMailManager = GetMailManager()

class CalenderViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GetMailManagerDelegate {
    
    @IBOutlet weak var controlViewView: ControlViewView!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var adMobView: AdMobView!
    
    private let monthName = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var showMonth: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlViewView.selectState = .month
        
        getMailManager.delegate = self
        getMailManager.startGetMail()
        
        classInfoData = classBox.datas
        
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        showMonth = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))!
        dateManager.changeMonth(date: showMonth)
        
        let monthNib = UINib(nibName: "MonthCollectionViewCell", bundle: nil)
        monthCollectionView.register(monthNib, forCellWithReuseIdentifier: "monthCell")
        monthCollectionView.delegate = self
        monthCollectionView.dataSource = self
        
        adMobView.start()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getMailRequestSuccess() {
        // 表示されている月をリロード
        let monthCell = monthCollectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as! MonthCollectionViewCell
        classInfoData = classBox.datas
        
        monthCell.dayCollectionView.reloadData()
        monthCell.dayClassScheduleView.reloadData()
    }
    
    func getMailRequestError() { }
    
    /// 今月を表示する
    func showThisMonth() {
        
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        showMonth = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))!
        dateManager.changeMonth(date: showMonth)
        
        firstLoadFlag = true
        
        monthCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var year = Calendar.current.component(.year, from: showMonth)
        var month = Calendar.current.component(.month, from: showMonth) + indexPath.row - 1
        if month == 0 { month = 12; year -= 1 }
        if month == 13 { month = 1; year += 1 }
        showMonth = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))!
        dateManager.changeMonth(date: showMonth)
        
        let monthCell = monthCollectionView.dequeueReusableCell(withReuseIdentifier: "monthCell", for: indexPath) as! MonthCollectionViewCell
        monthCell.yearLabel.text = String(year)
        monthCell.monthLabel.text = monthName[month-1]
        monthCell.year = year
        monthCell.month = month
        
        monthCell.viewSize = CGSize(width: collectionView.frame.size.width, height: collectionView.frame.height-60-120-5)
        monthCell.dayClassScheduleView.viewSize = CGSize(width: collectionView.frame.size.width, height: 120)
        
        classInfoData = classBox.datas
        
        // リロード
        monthCell.dayCollectionView.reloadData()
        monthCell.dayClassScheduleView.reloadData(indexPath: IndexPath(row: 0, section: 0))
        
        return monthCell
    }
    
    /// 初回ロード
    var firstLoadFlag = true
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if firstLoadFlag {
            monthCollectionView.contentOffset.x = monthCollectionView.frame.size.width
            
            let year = Calendar.current.component(.year, from: showMonth)
            let month = Calendar.current.component(.month, from: showMonth) + 1
            showMonth = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))!
            dateManager.changeMonth(date: showMonth)
        }
    }
    
    /// 画面に表示された時
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if firstLoadFlag { firstLoadFlag = false; return }
        
        let center = self.view.convert(monthCollectionView.center, to: monthCollectionView)
        guard let index = monthCollectionView.indexPathForItem(at: center) else { return }
        
        let monthCell = monthCollectionView.cellForItem(at: index) as! MonthCollectionViewCell

        let year = monthCell.year
        let month = monthCell.month
        showMonth = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))!
        dateManager.changeMonth(date: showMonth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return monthCollectionView.frame.size
    }
    
    /// 無限スクロール（端まで行ったら中央に戻す）
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= monthCollectionView.frame.size.width*2.0 {
            monthCollectionView.reloadData()
            scrollView.contentOffset.x = monthCollectionView.frame.size.width
        }
    }
}
