//
//  MailDatas.swift
//  classic
//
//  Created by kaichan on 2018/04/20.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

var classBox: ClassDataBox = ClassDataBox()

class ClassData: NSObject, NSCoding {
    
    var className: String = ""
    var classNumber: String = ""
    var classRoom: String = ""
    var classType: String = ""
    
    required init(coder aDecoder: NSCoder) {
        className = aDecoder.decodeObject(forKey: "className") as! String
        classNumber = aDecoder.decodeObject(forKey: "classNumber") as! String
        classRoom = aDecoder.decodeObject(forKey: "classRoom") as! String
        classType = aDecoder.decodeObject(forKey: "classType") as? String ?? ""
    }
    
    override init() { }
    
    init(name: String, number: String, room: String, type: String) {
        self.className = name
        self.classNumber = number
        self.classRoom = room
        self.classType = type
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(className, forKey: "className")
        aCoder.encode(classNumber, forKey: "classNumber")
        aCoder.encode(classRoom, forKey: "classRoom")
        aCoder.encode(classType, forKey: "classType")
    }
}

class ClassDataBox {
    
    var datas: [Date:[ClassData]] = [:]
    
    init() {
        if let value = value() {
            datas = value
        }
    }
    
    // データの保存
    func set(_ value: [Date:[ClassData]]) {
        datas = value
        
        let value_data = NSKeyedArchiver.archivedData(withRootObject: value)
        
        if let url = getApplicationSupportURL(fileName: "ClassDatas") {
            do {
                try value_data.write(to: url, options: .atomic)
            }
            catch { NSLog("授業データ保存に失敗") }
        }
    }
    
    // データの取り出し
    func value() -> [Date:[ClassData]]? {
        if let url = getApplicationSupportURL(fileName: "ClassDatas") {
            var value_data: Data!
            do {
                value_data = try Data(contentsOf: url, options: [])
            }
            catch { NSLog("授業データ読み込みに失敗") }
            
            if let data = value_data {
                let value: [Date:[ClassData]] = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Date:[ClassData]]
                return value
            }
        }
        return nil
    }
    
    private func getApplicationSupportURL(fileName: String) -> URL? {
        
        var applicationSupportURL: URL!
        do {
            let fm = FileManager.default
            let applicationSupportPath = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            applicationSupportURL = applicationSupportPath.appendingPathComponent(fileName)
        }
        catch { NSLog("パスの取得に失敗") }
        return applicationSupportURL
    }
}
class TempClassDataBox {
    
    // データの保存
    func set(_ value: [Date:[ClassData]]) {
        let value_data = NSKeyedArchiver.archivedData(withRootObject: value)
        
        if let url = getApplicationSupportURL(fileName: "tempClassDatas") {
            do {
                try value_data.write(to: url, options: .atomic)
            }
            catch { NSLog("temp授業データ保存に失敗") }
        }
    }
    
    // データの取り出し
    func value() -> [Date:[ClassData]]? {
        
        if let url = getApplicationSupportURL(fileName: "tempClassDatas") {
            var value_data: Data!
            do {
                value_data = try Data(contentsOf: url, options: [])
            }
            catch { NSLog("temp授業データ読み込みに失敗") }
            
            if let data = value_data {
                let value: [Date:[ClassData]] = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Date:[ClassData]]
                return value
            }
        }
        return nil
    }
    
    private func getApplicationSupportURL(fileName: String) -> URL? {
        
        var applicationSupportURL: URL!
        do {
            let fm = FileManager.default
            let applicationSupportPath = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            applicationSupportURL = applicationSupportPath.appendingPathComponent(fileName)
        }
        catch { NSLog("パスの取得に失敗") }
        return applicationSupportURL
    }
}
