//
//  GetMail_Toyohashi.swift
//  classic
//
//  Created by kaichan on 2018/04/25.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class GetMail_Toyohashi: NSObject {
    
    private var tempBox: TempClassDataBox = TempClassDataBox()
    private var collectedClass: [Date:[ClassData]] = [:]
    
    /// 補講のお知らせメールか否か
    func isClassInfoMail(subject: String, from: String) -> Bool {
        
        for i in 0 ..< classType_toyohashi.count {
            if subject.contains(classType_toyohashi[i] + "のお知らせ") && from.contains("kyoumu@office.tut.ac.jp") {
                return true
            }
        }
        return false
    }
    
    /// クラス情報を追加する
    func addClassInfoMail(body: String) {
        let type = searchClassType(body: body, keys: classType_toyohashi)
        
        let name = searchClassInfo(body: body, key: "時間割名：")
        let number = searchClassInfo(body: body, key: "時限：")
        let room = searchClassInfo(body: body, key: "教室：")
        let dateString = searchClassInfo(body: body, key: (type + "日："))
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        let date = formatter.date(from: dateString)!
        
        let cls = ClassData(name: name, number: number, room: room, type: type)
        
        // UserDefaultsに保存
        if collectedClass[date] == nil { collectedClass[date] = [] } // 初期化
        collectedClass[date]?.append(cls)
        removeSameClassData(date: date)
        tempBox.set(collectedClass)
    }
    
    /// クラスのタイプを返す example:休講, 補講
    private func searchClassType(body: String, keys: [String]) -> String {
        
        if let range = body.range(of: "備考") {   // 備考までで文章を切る(学生へのメッセージを含めないため)
            let n: Int = body.distance(from: body.startIndex, to: range.lowerBound)
            let startIndex = body.index(body.startIndex, offsetBy: n)
            let body2 = body[...startIndex]
            
            for key in keys {
                if body2.range(of: key) != nil {
                    return key
                }
            }
        }
        
        return ""
    }
    
    /// クラスの情報を返す
    private func searchClassInfo(body: String, key: String) -> String {
        
        if let range = body.range(of: key) {
            let n: Int = body.distance(from: body.startIndex, to: range.lowerBound)
            let startIndex = body.index(body.startIndex, offsetBy: n + key.count)
            let body2 = body[startIndex...] // endIndexはstartIndexより後ろにある
            if let endIndex = body2.index(of: "（") {
                var info = body2[startIndex...endIndex]
                info = info[info.startIndex..<info.index(before: info.endIndex)]
                return String(info)
            }
            if let endIndex = body2.index(of: " ") {
                var info = body2[startIndex...endIndex]
                info = info[info.startIndex..<info.index(before: info.endIndex)]
                return String(info)
            }
        }
        
        return ""
    }
    
    /// データが重複して登録されてしまうのを避ける
    private func removeSameClassData(date: Date) {
        let c = collectedClass[date]!
        let orderedSet: NSOrderedSet = NSOrderedSet(array: c)
        let c2 = orderedSet.array as! [ClassData]
        collectedClass[date] = c2
    }
    
    func initializeCollectedClass() {
        tempBox = TempClassDataBox()
        collectedClass = [:]
    }
    
    func getClassBox() -> [Date:[ClassData]] {
        return tempBox.value()!
    }
}
