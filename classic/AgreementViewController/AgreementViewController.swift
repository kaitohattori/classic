//
//  AgreementViewController.swift
//  classic
//
//  Created by kaichan on 2018/05/13.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class AgreementViewController: UIViewController {
    
    @IBOutlet weak var agreementTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        agreementTextView.text = readAgreementDocument()
    }
    
    @IBAction func agreeClicked(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "isAgree")
        
        // 画面遷移
        self.dismiss(animated: true, completion: nil)
    }
    
    private func readAgreementDocument() -> String {
        var fileName = ""
        
        let prefLang = Locale.preferredLanguages.first!
        if prefLang.hasPrefix("ja"){
            fileName = "agreement-ja"
        }
        else {
            fileName = "agreement-en"
        }
        
        let path = Bundle.main.path(forResource: fileName, ofType: "txt")!
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let text = String(data: data, encoding: .utf8)
            return text!
        }
        catch { }
        return ""
    }
}
