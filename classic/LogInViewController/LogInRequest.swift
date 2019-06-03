//
//  LogInRequest.swift
//  classic
//
//  Created by kaichan on 2018/04/15.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

protocol LogInRequestDelegate: class {
    func loginRequestSuccess(mail: String, password: String, hostname: String)
    func loginRequestError()
}

class LogInRequest: NSObject {
    
    weak var delegate: LogInRequestDelegate!
    private var errorCount: Int = 0
    
    func login(address: String, password: String) {
        SVProgressHUD.show(withStatus: "Login...")
        
        if !isSupportSchool(address: address) { return }              // 対応した学校かどうか
        
        errorCount = 0
        for i in 0 ..< hostnames.count {
            
            let session: MCOIMAPSession = MCOIMAPSession()
            session.hostname = hostnames[i]
            session.port     = 993
            session.username = address
            session.password = password
            session.connectionType = MCOConnectionType.TLS
            
            let folder = "INBOX"
            let requestKind = MCOIMAPMessagesRequestKind.flags
            let uidSet: MCOIndexSet = MCOIndexSet(range: MCORange(location: 1, length: 1))
            let fetchOperation: MCOIMAPFetchMessagesOperation =
                session.fetchMessagesOperation(withFolder: folder, requestKind: requestKind, uids: uidSet)
            fetchOperation.start { (error, messages, vanished) -> Void in
                if (error != nil) {
                    
                    // 全てのhostnameを試してダメだったら
                    self.errorCount += 1
                    self.wait( { return self.errorCount != hostnames.count } ) {
                        // ログイン失敗
                        SVProgressHUD.showError(withStatus: "Login Error")
                        SVProgressHUD.dismiss(withDelay: 1.0)
                        if self.delegate != nil { self.delegate.loginRequestError() }
                        return
                    }
                    
                } else {
                    // ログイン成功
                    SVProgressHUD.showSuccess(withStatus: "Login Success")
                    SVProgressHUD.dismiss(withDelay: 1.0)
                    if self.delegate != nil { self.delegate.loginRequestSuccess(mail: address, password: password, hostname: hostnames[i]) }
                    self.waitCancel()
                    return
                }
            }
        }
    }
    
    private var cancel: Bool = false
    private func wait(_ waitContinuation: @escaping (()->Bool), compleation: @escaping (()->Void)) {
        var wait = waitContinuation()
        // 0.01秒周期で待機条件をクリアするまで待ちます。
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            while wait {
                DispatchQueue.main.async {
                    wait = waitContinuation()
                    semaphore.signal()
                }
                semaphore.wait()
                Thread.sleep(forTimeInterval: 0.01)
                
                if self.cancel { return }
            }
            // 待機条件をクリアしたので通過後の処理を行います。
            DispatchQueue.main.async {
                compleation()
            }
        }
    }
    private func waitCancel() {
        cancel = true
    }
    
    // 対応した学校かどうか
    private func isSupportSchool(address: String) -> Bool {
        for schoolMailAddress in schoolMailAddresses {
            if address.contains(schoolMailAddress) {
                return true
            }
        }
        // ログイン失敗
        SVProgressHUD.showError(withStatus: "Login Error")
        SVProgressHUD.dismiss(withDelay: 1.0)
        if self.delegate != nil { self.delegate.loginRequestError() }
        return false
    }
}
