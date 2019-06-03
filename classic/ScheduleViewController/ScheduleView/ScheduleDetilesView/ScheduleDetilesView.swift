//
//  ScheduleDetilesView.swift
//  classic
//
//  Created by kaichan on 8/19/18.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class ScheduleDetilesView: UIView {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var weekNumberLabel: UILabel!
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var classRoomTextField: UITextField!
    
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
        let view = Bundle.main.loadNibNamed("ScheduleDetilesView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
        view.autoLayout(to: self)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        mainView.layer.cornerRadius = 10
        
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.3
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 10
    }
    
    @IBAction func touchAnotherView(_ sender: Any) {
        hide()
    }
    
    func show(weekName: String, classNumber: Int, className: String, classRoom: String, color: UIColor) {
        showAnimation()
        
        self.weekNumberLabel.text = weekName + " - " + String(classNumber)
        self.classNameTextField.text = className
        self.classRoomTextField.text = classRoom
        self.mainView.backgroundColor = color
    }
    func hide(animation: Bool = true) {
        hideAnimation(animation: animation)
        
        self.endEditing(true)
    }
    
    private func showAnimation() {
        self.mainView.alpha = 0.0
        self.mainView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        self.isHidden = false
        
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
            self.mainView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.mainView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.05, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                self.mainView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
    }
    private func hideAnimation(animation: Bool = true) {
        if animation {
            
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                self.mainView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
                    self.mainView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    self.mainView.alpha = 0.0
                }) { _ in
                    self.isHidden = true
                }
            }
        }
        else {
            self.isHidden = true
        }
    }
}
