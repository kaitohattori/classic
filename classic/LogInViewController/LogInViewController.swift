//
//  LogInViewController.swift
//  classic
//
//  Created by kaichan on 2018/04/15.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, LogInRequestDelegate {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    let logInRequestController = LogInRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInRequestController.delegate = self
        
        mailTextField.isSecureTextEntry = false
        passTextField.isSecureTextEntry = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // 前回のmailとpasswordをロード
        let keychain = Keychain(service: config.KeychainService)
        var mail = ""; var password = ""
        do {
            mail = try keychain.get("mail") ?? ""
            password = try keychain.get("password") ?? ""
        } catch {
            NSLog("パスワードのロードに失敗")
        }
        
        mailTextField.text = mail
        passTextField.text = password
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        logInRequestController.login(address: mailTextField.text!, password: passTextField.text!)
    }
    
    @IBAction func skipClicked(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "isLogin")
        self.dismiss(animated: true, completion: nil)
    }
    
    func loginRequestSuccess(mail: String, password: String, hostname: String) {
        
        // mailとpasswordを保存
        let keychain = Keychain(service: config.KeychainService)
        do {
            try keychain.set(mail, key: "mail")
            try keychain.set(password, key: "password")
            try keychain.set(hostname, key: "hostname")
        } catch {
            NSLog("メールとパスワードの保存に失敗しました")
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "isLogin")
        
        // Taptic Engine
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        
        // 画面遷移
        self.dismiss(animated: true, completion: nil)
    }
    
    func loginRequestError() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: "islogin")
    }
    
}
