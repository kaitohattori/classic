//
//  GetMailDataManager.swift
//  classic
//
//  Created by kaichan on 2018/04/20.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

protocol GetMailManagerDelegate: class {
    func getMailRequestSuccess()
    func getMailRequestError()
}

class GetMailManager: NSObject {
    
    weak var delegate: GetMailManagerDelegate!
    
    private var getMailTimer: Timer!
    func startGetMail() {
        if getMailTimer != nil && getMailTimer.isValid { return }
        getMail() // はじめはメール取得
        getMailTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(GetMailManager.repeatGetMail), userInfo: nil, repeats: true)
    }
    func stopGetMail() {
        if getMailTimer != nil && getMailTimer.isValid {
            getMailTimer.invalidate()
            getMailTimer = nil
        }
    }
    @objc private func repeatGetMail() {
        getMail()
    }
    
    private var hostname: String = ""
    private var getMailSuccessTimer: Timer!
    func getMail() {
        let keychain = Keychain(service: config.KeychainService)
        var mail = ""; var password = ""
        do {
            mail = try keychain.get("mail") ?? ""
            password = try keychain.get("password") ?? ""
            hostname = try keychain.get("hostname") ?? ""
        } catch {
            NSLog("パスワードのロードに失敗")
        }
        
        NSLog("メール受信を開始しました")
        let session: MCOIMAPSession = MCOIMAPSession()
        session.hostname = hostname
        session.port     = 993
        session.username = mail
        session.password = password
        session.connectionType = MCOConnectionType.TLS
        
        let folder = "INBOX"
        let requestKind:MCOIMAPMessagesRequestKind = [.flags, .headers, .structure, .internalDate, .fullHeaders, .headerSubject, .extraHeaders]
        let uidSet: MCOIndexSet = MCOIndexSet(range: MCORange(location: 1, length: UINT64_MAX))
        let fetchOperation: MCOIMAPFetchMessagesOperation =
            session.fetchMessagesOperation(withFolder: folder, requestKind: requestKind, uids: uidSet)
        fetchOperation.start { (error, messages, vanished) -> Void in
            if (error != nil) {
                NSLog("メール受信に失敗しました")
                NSLog("\(error.debugDescription)")
                if self.delegate != nil { self.delegate.getMailRequestError() }
            } else {
                NSLog("メール受信に成功しました")
                
                for message in messages as! [MCOIMAPMessage] {
                    
                    // 初期化
                    self.initializeCollectedClass()
                    
                    let subject: String = message.header.subject ?? ""
                    let from: String = message.header.from.mailbox ?? ""
                    
                    // 件名と送り主を見て授業変更メールかどうか
                    if self.isClassInfoMail(subject: subject, from: from) {
                        
                        // bodyを取得
                        let op = session.fetchMessageOperation(withFolder: folder, uid: message.uid)
                        op?.start { (err, data) -> Void in
                            let msgParser = MCOMessageParser(data: data)
                            let body: String = msgParser!.plainTextBodyRendering() ?? ""
                            
                            // クラス情報を追加
                            self.addClassInfoMail(body: body)
                            
                            // メール取得の処理時間を考慮して遅延し、通知する
                            if self.getMailSuccessTimer != nil && self.getMailSuccessTimer.isValid {
                                self.getMailSuccessTimer.invalidate()
                            }
                            self.getMailSuccessTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(GetMailManager.successGetMail), userInfo: nil, repeats: false)
                        }
                    }
                    
                }
    
            }
        }
    }
    @objc private func successGetMail() {
        NSLog("メールを処理しました")
        switch hostname {
        case "imap.gmail.com":
            classBox.set(demo.getClassBox())
            break
            
        case "outlook.office365.com":
            classBox.set(toba.getClassBox())
            break
            
        case "mail.imc.tut.ac.jp":
            classBox.set(toyohashi.getClassBox())
            break
            
        default:
            break
        }
        if self.delegate != nil { self.delegate.getMailRequestSuccess() }
    }
    
    /// collectedClass を初期化
    private func initializeCollectedClass() {
        switch hostname {
        case "imap.gmail.com":
            demo.initializeCollectedClass()
            break
            
        case "outlook.office365.com":
            toba.initializeCollectedClass()
            break
            
        case "mail.imc.tut.ac.jp":
            toyohashi.initializeCollectedClass()
            break
            
        default:
            break
        }
    }
    
    /// 補講のお知らせメールか否か
    private func isClassInfoMail(subject: String, from: String) -> Bool {
        
        switch hostname {
        case "imap.gmail.com":
            return demo.isClassInfoMail(subject: subject, from: from)
            
        case "outlook.office365.com":
            return toba.isClassInfoMail(subject: subject, from: from)
            
        case "mail.imc.tut.ac.jp":
            return toyohashi.isClassInfoMail(subject: subject, from: from)
            
        default:
            return false
        }
    }
    
    /// クラス情報を追加する
    private func addClassInfoMail(body: String) {
        
        switch hostname {
        case "imap.gmail.com":
            demo.addClassInfoMail(body: body)
            break
            
        case "outlook.office365.com":
            toba.addClassInfoMail(body: body)
            break
            
        case "mail.imc.tut.ac.jp":
            toyohashi.addClassInfoMail(body: body)
            break
            
        default:
            break
        }
    }
}
