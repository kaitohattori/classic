//
//  DateManager.swift
//  classic
//
//  Created by kaichan on 2018/04/17.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class DateManager: NSObject {
    var currentMonthOfDates = [Date]() //表記する月の配列
    var selectedDate = Date()
    let daysPerWeek: Int = 7
    var numberOfItems: Int = 7 * 6
    
    /// 月の初日を取得
    func firstDateOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        components.day = 1
        let firstDateMonth = Calendar.current.date(from: components)!
        return firstDateMonth
    }
    
    /// ⑴表記する日にちの取得
    func setCurrentMonthOfDates() {
        currentMonthOfDates = []
        let ordinalityOfFirstDay = Calendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth())
        for i in 0 ..< numberOfItems {
            var dateComponents = DateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay! - 1)
            let date = Calendar.current.date(byAdding: dateComponents as DateComponents, to: firstDateOfMonth())!
            currentMonthOfDates.append(date)
        }
    }
    
    /// ⑵表記の変更
    func conversionDayFormat(indexPath: IndexPath) -> String {
        if currentMonthOfDates.count == 0 { setCurrentMonthOfDates() }
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: currentMonthOfDates[indexPath.row])
    }
    
    func conversionDateFormat(indexPath: IndexPath) -> Date {
        if currentMonthOfDates.count == 0 { setCurrentMonthOfDates() }
        
        return currentMonthOfDates[indexPath.row]
    }
    
    func conversionWeekNameFormat(indexPath: IndexPath) -> String {
        if currentMonthOfDates.count == 0 { setCurrentMonthOfDates() }
        let date = currentMonthOfDates[indexPath.row]
        
        let weekNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let comp = Calendar.Component.weekday
        let weekday = Calendar.current.component(comp, from: date)
        return weekNames[weekday - 1]
    }
    
    func getYear() -> Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDate)
        return year
    }
    func getMonth() -> Int {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: selectedDate)
        return month
    }
    
    func changeMonth(date: Date) {
        currentMonthOfDates = []
        selectedDate = date
    }
    
    //前月
    func prevMonth(date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: date)!
        return selectedDate
    }
    
    //次月
    func nextMonth(date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: date)!
        return selectedDate
    }
}
