//
//  ControlViewView.swift
//  classic
//
//  Created by kaichan on 2018/05/19.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

enum ControllViewViewSelectState: Int {
    case week = 1
    case month = 2
}

class ControlViewView: UIView {
    
    @IBOutlet weak private var weekView: UIView!
    @IBOutlet weak private var monthView: UIView!
    @IBOutlet weak private var selectBar: UIView!
    var selectState: ControllViewViewSelectState!
    
    init(sender: UIViewController) {
        super.init(frame: sender.view.frame)
        loadNib()
        sender.view.addSubview(self)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    private func loadNib(){
        let view = Bundle.main.loadNibNamed("ControlViewView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
        view.autoLayout(to: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            
            if self.selectState == .week {
                self.selectBar.frame.origin.x = self.weekView.frame.origin.x
            }
            else {
                self.selectBar.frame.origin.x = self.monthView.frame.origin.x
            }
        }
    }
    
    @IBAction func weekClicked(_ sender: Any) {
        
        if selectState != .week {
            UIView.animate(withDuration: 0.07, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                self.selectBar.frame.origin.x = self.weekView.frame.origin.x + self.weekView.frame.size.width/5*4
            }) { _ in
                UIView.animate(withDuration: 0.07, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                    self.selectBar.frame.origin.x = self.weekView.frame.origin.x + self.weekView.frame.size.width/5
                }) { _ in
                    UIView.animate(withDuration: 0.07, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                        self.selectBar.frame.origin.x = self.weekView.frame.origin.x
                    }) { _ in
                        
                        self.presentScheduleVC()
                    }
                }
            }
        }
        
        selectState = .week
    }
    
    @IBAction func monthClicked(_ sender: Any) {
        
        if selectState != .month {
            UIView.animate(withDuration: 0.07, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                self.selectBar.frame.origin.x = self.monthView.frame.origin.x - self.monthView.frame.size.width/5*4
            }) { _ in
                UIView.animate(withDuration: 0.07, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                    self.selectBar.frame.origin.x = self.monthView.frame.origin.x - self.monthView.frame.size.width/5
                }) { _ in
                    UIView.animate(withDuration: 0.07, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                        self.selectBar.frame.origin.x = self.monthView.frame.origin.x
                    }) { _ in
                        
                        self.presentCalenderVC()
                    }
                }
            }
        }
        
        selectState = .month
    }
    
    @IBAction func settingClicked(_ sender: Any) {
        presentSettingVC()
    }
    
    private func presentCalenderVC() {
        if let viewController = self.parentViewController() as? ScheduleViewController {
            let story = UIStoryboard(name: "CalenderViewController", bundle: nil)
            let next = story.instantiateViewController(withIdentifier: "CalenderViewController") as! CalenderViewController
            next.modalTransitionStyle = .crossDissolve
            viewController.present(next, animated: false, completion: nil)
        }
    }
    
    private func presentScheduleVC() {
        if let viewController = self.parentViewController() as? CalenderViewController {
            let story = UIStoryboard(name: "ScheduleViewController", bundle: nil)
            let next = story.instantiateViewController(withIdentifier: "ScheduleViewController") as! ScheduleViewController
            next.modalTransitionStyle = .crossDissolve
            viewController.present(next, animated: false, completion: nil)
        }
    }
    
    private func presentSettingVC() {
        if let viewController = self.parentViewController() {
            let story = UIStoryboard(name: "SettingViewController", bundle: nil)
            let next = story.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
            viewController.present(next, animated: true, completion: nil)
        }
    }
}
