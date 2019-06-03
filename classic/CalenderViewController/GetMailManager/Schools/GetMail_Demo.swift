//
//  GetMail_Demo.swift
//  classic
//
//  Created by kaichan on 6/13/18.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class GetMail_Demo: NSObject {
    
    private var tempBox: TempClassDataBox = TempClassDataBox()
    private var collectedClass: [Date:[ClassData]] = [:]
    
    /// 授業変更メールか否か
    func isClassInfoMail(subject: String, from: String) -> Bool {
        if subject.contains("講義変更のお知らせ") {
            return true
        }
        return false
    }
    
    /// クラス情報を追加する
    func addClassInfoMail(body: String) {
        let count = numberOfOccurrences(body: body, word: "<")
        
        var body = body.replacingOccurrences(of:"-", with:"")
        body     = body.replacingOccurrences(of:"選", with:"")
        var classInfoArray = body.components(separatedBy: "<")
        classInfoArray.removeFirst()
        for i in 0 ..< count {
            let classInfo = classInfoArray[i]
            
            let type = classInfo.components(separatedBy: ">").first!
            
            var infoArray = classInfo.components(separatedBy: " ")
            
            var i = 0
            while i < infoArray.count {
                if infoArray[i] == "" {
                    infoArray.remove(at: i)
                }
                else {
                    i += 1
                }
            }
            
            let a = infoArray[1].components(separatedBy: "!")
            infoArray[1] = a[0]
            infoArray.insert(a[1], at: 2)
            
            if infoArray.count < 6 { infoArray.append("") }
            
            let name         = infoArray[4]
            let numberString = infoArray[2]
            let room         = infoArray[5]
            let dateString   = infoArray[1]
            
            let numberArray = convertNumberArray(numberString: numberString)
            
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy年MM月dd日"
            formatter.locale = Locale(identifier: "ja_JP")
            let date = formatter.date(from: dateString)!
            
            // UserDefaultsに保存
            if collectedClass[date] == nil { collectedClass[date] = [] } // 初期化
            for i in 0 ..< numberArray.count {
                let cls = ClassData(name: name, number: String(numberArray[i]), room: room, type: type)
                if removeSameClassNumber(date: date, number: numberArray[i], type: type) {
                    collectedClass[date]?.append(cls)
                }
            }
            removeSameClassData(date: date)
            tempBox.set(collectedClass)
        }
    }
    
    /// 幾つ情報が載っているか数える
    private func numberOfOccurrences(body: String, word: String) -> Int {
        var count = 0
        var nextRange = body.startIndex..<body.endIndex
        while let range = body.range(of: word, options: .caseInsensitive, range: nextRange) {
            count += 1
            nextRange = range.upperBound..<body.endIndex
        }
        return count
    }
    
    /// 5限,6限,7限 -> [5, 6, 7]
    private func convertNumberArray(numberString: String) -> [Int] {
        let numberString = numberString.replacingOccurrences(of:"限", with:"")
        let array = numberString.components(separatedBy: ",")
        var nums: [Int] = []
        for i in 0 ..< array.count {
            let str = array[i]
            if let num = Int(str) {
                nums.append(num)
            }
        }
        return nums
    }
    
    /// データが重複して登録されてしまうのを避ける
    private func removeSameClassData(date: Date) {
        let c = collectedClass[date]!
        let orderedSet: NSOrderedSet = NSOrderedSet(array: c)
        let c2 = orderedSet.array as! [ClassData]
        collectedClass[date] = c2
    }
    
    private func removeSameClassNumber(date: Date, number: Int, type: String) -> Bool {
        var sameDataNumber = -1
        var removeType = ""
        if let collectedClassArray = collectedClass[date] {
            for i in 0 ..< collectedClassArray.count {
                if collectedClassArray[i].classNumber == String(number) {
                    
                    sameDataNumber = i
                    removeType = collectedClassArray[i].classType
                    break
                }
            }
        }
        if sameDataNumber != -1 {
            if removeType == "変更後" && type == "変更前" {
                return false
            }
            else if type == "追加" || type == "変更後" || type == "代替" || type == "休講" {
                collectedClass[date]?.remove(at: sameDataNumber)
                return true
            }
            else {
                return false
            }
        }
        return true
    }
    
    /// 初期化
    func initializeCollectedClass() {
        tempBox = TempClassDataBox()
    }
    
    func getClassBox() -> [Date:[ClassData]] {
        return tempBox.value()!
    }
}
