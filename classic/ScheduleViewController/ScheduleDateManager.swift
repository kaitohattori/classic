//
//  ScheduleVCDateManager.swift
//  classic
//
//  Created by kaichan on 2018/05/19.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class ScheduleDateManager: NSObject {
    
    func getWeekDays() -> [String] {
        var weekDays: [String] = []
        
        let comp = Calendar.Component.weekday
        let weekday = Calendar.current.component(comp, from: Date())
        for i in 0 ..< 5 {
            let difference = i - weekday + 2
            let date = Calendar.current.date(byAdding: .day, value: difference, to: Date())!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            dateFormatter.locale = Locale.init(identifier: "ja_JP")
            let monToFriDate = dateFormatter.string(from: date)
            weekDays.append(monToFriDate)
        }
        return weekDays
    }
    
    func getWeekDates() -> [Date] {
        var weekDates: [Date] = []
        
        let comp = Calendar.Component.weekday
        let weekday = Calendar.current.component(comp, from: Date())
        for i in 0 ..< 5 {
            let difference = i - weekday + 2
            let date = Calendar.current.date(byAdding: .day, value: difference, to: Date())!
            
            // convert [year, month, day] only date
            let cleanComp = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let cleanDate = Calendar.current.date(from: cleanComp)!
            
            weekDates.append(cleanDate)
        }
        return weekDates
    }
    
/*
    // 日付を試すメソッド
    func getWeekDates() -> [Date] {
        var weekDates: [Date] = []
        
        let formatter = DateFormatter()
        let now = "2017年12月4日"
        formatter.dateFormat = "yyyy年MM月dd日"
        formatter.locale = Locale(identifier: "ja_JP")
        let xdate = formatter.date(from: now)!
        
        let comp = Calendar.Component.weekday
        let weekday = Calendar.current.component(comp, from: xdate)
        for i in 0 ..< 5 {
            let difference = i - weekday + 2
            let date = Calendar.current.date(byAdding: .day, value: difference, to: xdate)!
            
            weekDates.append(date)
        }
        return weekDates
    }
 */
}
