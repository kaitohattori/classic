//
//  FirstLoadViewController.swift
//  classic
//
//  Created by kaichan on 2018/04/23.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isAgree() {       present(to: "AgreementViewController");     return }
        if !isLogin() {       present(to: "LogInViewController");         return }
        if !isSetSchedule() { present(to: "SetScheduleViewController");   return }
        if !isLoadMail() {    present(to: "FirstMailLoadViewController"); return }
//        present(to: "CalenderViewController", animation: true)
        present(to: "ScheduleViewController", animation: true)
    }
    
    private func isAgree() -> Bool {
        let userDefaults = UserDefaults.standard
        let isagree = userDefaults.bool(forKey: "isAgree")
        return isagree
    }
    private func isLogin() -> Bool {
        let userDefaults = UserDefaults.standard
        let islogin = userDefaults.bool(forKey: "isLogin")
        return islogin
    }
    private func isSetSchedule() -> Bool {
        let userDefaults = UserDefaults.standard
        let issetschedule = userDefaults.bool(forKey: "isSetSchedule")
        return issetschedule
    }
    private func isLoadMail() -> Bool {
        let userDefaults = UserDefaults.standard
        let isloadmail = userDefaults.bool(forKey: "isLoadMail")
        return isloadmail
    }
    
    private func present(to identifier: String, animation: Bool = false) {
        if animation {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let story = UIStoryboard(name: identifier, bundle: nil)
                let next = story.instantiateViewController(withIdentifier: identifier)
                next.modalTransitionStyle = .crossDissolve
                self.present(next, animated: true, completion: nil)
            }
        }
        else {
            let story = UIStoryboard(name: identifier, bundle: nil)
            let next = story.instantiateViewController(withIdentifier: identifier)
            self.present(next, animated: true, completion: nil)
        }
    }
}
