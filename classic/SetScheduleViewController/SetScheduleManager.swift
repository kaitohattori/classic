//
//  SetScheduleManager.swift
//  classic
//
//  Created by kaichan on 2018/05/16.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

var scheduleManager: ScheduleManager = ScheduleManager()

protocol ScheduleManagerDelegate: class {
    func recievedClassScheduleFromAirDrop()
}

class ScheduleManager: NSObject {
    
    weak var delegate: ScheduleManagerDelegate!
    
    private var retentionJSON: [String:Any] = [:]
    private let weekNames = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    
    override init() {
        super.init()
        
        if !isSetup() {
            setupJsonFile()
        }
        
        if let json = getJSON() {
            retentionJSON = json
        }
     }
    
    func set(weekName: String, classNumber: Int, className: String, classRoom: String, color: UIColor) {
        
        if var json = getJSON() {
            
            var weekInfo  = json[weekName] as! [String:Any]
            var classInfo = weekInfo[String(classNumber)] as! [String:Any]
            var colorInfo = classInfo["color"] as! [String:Any]
            colorInfo["red"]   = color.r
            colorInfo["green"] = color.g
            colorInfo["blue"]  = color.b
            colorInfo["alpha"] = color.a
            
            classInfo["className"] = className
            classInfo["classRoom"] = classRoom
            classInfo["color"]     = colorInfo
            
            weekInfo[String(classNumber)] = classInfo
            json[weekName] = weekInfo
            
            saveJSON(json: json)
            retentionJSON = json
        }
        
    }
    
    func getClassName(weekName: String, classNumber: Int) -> String {
        
        let weekInfo  = retentionJSON[weekName] as! [String:Any]
        let classInfo = weekInfo[String(classNumber)] as! [String:Any]
        return classInfo["className"] as! String
    }
    
    func getClassRoom(weekName: String, classNumber: Int) -> String {
        
        let weekInfo  = retentionJSON[weekName] as! [String:Any]
        let classInfo = weekInfo[String(classNumber)] as! [String:Any]
        return classInfo["classRoom"] as! String
    }
    
    func getColor(weekName: String, classNumber: Int) -> UIColor {
        
        let weekInfo  = retentionJSON[weekName] as! [String:Any]
        let classInfo = weekInfo[String(classNumber)] as! [String:Any]
        let colorInfo = classInfo["color"] as! [String:Any]
        
        let red   = CGFloat(colorInfo["red"] as! Int) / 255.0
        let green = CGFloat(colorInfo["green"] as! Int) / 255.0
        let blue  = CGFloat(colorInfo["blue"] as! Int) / 255.0
        let alpha = CGFloat(colorInfo["alpha"] as! Int) / 255.0
        
        // 四捨五入
        let roundRed   = round(red * 100) / 100
        let roundGreen = round(green * 100) / 100
        let roundBlue  = round(blue * 100) / 100
        let roundAlpha = round(alpha * 100) / 100
        
        return UIColor(red: roundRed, green: roundGreen, blue: roundBlue, alpha: roundAlpha)
    }
    
    func removeData(weekName: String, classNumber: Int) {
        
        if var json = getJSON() {
            
            var weekInfo  = json[weekName] as! [String:Any]
            var classInfo = weekInfo[String(classNumber)] as! [String:Any]
            var colorInfo = classInfo["color"] as! [String:Any]
            colorInfo["red"]   = 255
            colorInfo["green"] = 255
            colorInfo["blue"]  = 255
            colorInfo["alpha"] = 255
            
            classInfo["className"] = ""
            classInfo["classRoom"] = ""
            classInfo["color"]     = colorInfo
            
            weekInfo[String(classNumber)] = classInfo
            json[weekName] = weekInfo
            
            saveJSON(json: json)
            retentionJSON = json
        }
    }
    
    private func getJSON() -> [String:Any]? {
        if let url = getApplicationSupportURL(fileName: "ClassSchedule.json") {
            var json_data: Data!
            do {
                json_data = try Data(contentsOf: url, options: [])
            }
            catch { NSLog("ClassSchedule.json読み込みに失敗") }
            
            if let data = json_data {
                let jsonStr = String(bytes: data, encoding: .utf8)!
                let json = JSONParseDictionary(jsonString: jsonStr)
                
                return json
            }
        }
        return nil
    }
    
    private func saveJSON(json: [String:Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            if let url = getApplicationSupportURL(fileName: "ClassSchedule.json") {
                do {
                    try jsonData.write(to: url, options: .atomic)
                }
                catch { NSLog("ClassSchedule.jsonの保存に失敗") }
            }
        }
        catch { NSLog("ClassSchedule.jsonの保存に失敗") }
    }
    
    private func JSONParseDictionary(jsonString: String) -> [String: Any] {
        if let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                return dictionary
            }
            catch { }
        }
        return [String: Any]()
    }
    
    private func isSetup() -> Bool {
        if let url = getApplicationSupportURL(fileName: "ClassSchedule.json") {
            do {
                _ = try Data(contentsOf: url, options: [])
                return true
            }
            catch { }
        }
        return false
    }
    
    private func setupJsonFile() {
        
        var weekInfo = Dictionary<String,Any>()
        for week in weekNames {
            
            var numberInfo = Dictionary<String,Any>()
            for number in 1 ..< 9 {
                let numberStr = String(number)
                
                var classInfo = Dictionary<String,Any>()
                classInfo["className"] = ""
                classInfo["classRoom"] = ""
                
                var colorInfo = Dictionary<String,Any>()
                colorInfo["red"] = 255
                colorInfo["green"] = 255
                colorInfo["blue"] = 255
                colorInfo["alpha"] = 255
                
                classInfo["color"] = colorInfo
                
                numberInfo[numberStr] = classInfo
                
                weekInfo[week] = numberInfo
            }
        }
        
        saveJSON(json: weekInfo)
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
    private func getTemporaryURL(fileName: String) -> URL {
        
        let temproraryURL = FileManager.default.temporaryDirectory
        let temproraryFileURL = temproraryURL.appendingPathComponent(fileName)
        return temproraryFileURL
    }
    
    func getManagementJSONFileURL() -> URL? {
        if let url = getApplicationSupportURL(fileName: "ClassSchedule.json") {
            
            let newURL = getTemporaryURL(fileName: "ClassSchedule.json.managementclass")
            let manager = FileManager()
            do {
                if manager.fileExists(atPath: newURL.path) {
                    try manager.removeItem(at: newURL)
                }
                try manager.copyItem(at: url, to: newURL)
                return newURL
            }
            catch { NSLog("ClassSchedule.json.managementclassの読み込みに失敗") }
            
        }
        return nil
    }
    func recieveManagementJSONFile(url recievedURL: URL) {
        if let url = getApplicationSupportURL(fileName: "ClassSchedule.json") {
            let manager = FileManager()
            do {
                if manager.fileExists(atPath: url.path) {
                    try manager.removeItem(at: url)
                }
                try manager.moveItem(at: recievedURL, to: url)
                
                if delegate != nil { delegate.recievedClassScheduleFromAirDrop() }
                NSLog("ClassSchedule.jsonの受信に成功")
            }
            catch { NSLog("ClassSchedule.jsonの受信に失敗") }
        }
    }
}

extension UIColor {
    
    var r: Int { return Int(self.cgColor.components![0] * 255) }
    
    var g: Int { return Int(self.cgColor.components![1] * 255) }
    
    var b: Int { return Int(self.cgColor.components![2] * 255) }
    
    var a: Int { return Int(self.cgColor.components![3] * 255) }
}
