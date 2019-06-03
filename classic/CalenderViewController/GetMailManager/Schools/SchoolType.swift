//
//  SchoolType.swift
//  classic
//
//  Created by kaichan on 2018/04/25.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

let demo = GetMail_Demo()
let toba = GetMail_Toba()
let toyohashi = GetMail_Toyohashi()

let schoolMailAddresses: [String] = ["kaito.developer.managementclass@gmail.com", "@toba.kosen-ac.jp", "@edu.tut.ac.jp"]
let hostnames: [String] = ["imap.gmail.com", "outlook.office365.com", "mail.imc.tut.ac.jp"]

let classType_toba: [String] = ["代替", "休講", "追加", "変更前", "変更後"]
let classType_toyohashi: [String] = ["補講", "休講"]

let classTypeColor: [String : UIColor] = ["補講":.mainorange, "代替":.mainorange, "休講":.skyblue, "追加":.mainorange, "変更前":.skyblue, "変更後":.mainorange]

extension UIColor {
    static let mainorange = UIColor(red:1.0, green:0.6, blue:0.2, alpha:1.0)
    static let skyblue = UIColor(red:0.1, green:0.7, blue:1.0, alpha:1.0)
    static let mainred = UIColor(red:1.0, green:0.3, blue:0.3, alpha:1.0)
}
