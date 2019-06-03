//
//  SetScheduleView.swift
//  classic
//
//  Created by kaichan on 2018/05/14.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

protocol SetScheduleViewDelegate: class {
    func setSchedule(weekName: String, classNumber: Int, className: String, classRoom: String, color: UIColor)
}

class SetScheduleView: UIView, UITextFieldDelegate {
    
    weak var delegate: SetScheduleViewDelegate!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var weekNumberLabel: UILabel!
    @IBOutlet weak var colorSelectCollectionView: SetScheduleViewColorSelectView!
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var classRoomTextField: UITextField!
    
    private var weekName: String = ""
    private var classNumber: Int = 0
    
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
        let view = Bundle.main.loadNibNamed("SetScheduleView", owner: self, options: nil)?.first as! UIView
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
        
        classNameTextField.delegate = self
        classRoomTextField.delegate = self
        classNameTextField.returnKeyType = .next
        classRoomTextField.returnKeyType = .done
    }
    
    @IBAction func touchAnotherView(_ sender: Any) {
        hide()
    }
    
    func show(weekName: String, classNumber: Int, className: String, classRoom: String, color: UIColor) {
        showAnimation()
        
        classNameTextField.becomeFirstResponder()
        
        weekNumberLabel.text = weekName + " - " + String(classNumber)
        self.weekName = weekName
        self.classNumber = classNumber
        
        classNameTextField.text = className
        classRoomTextField.text = classRoom
        colorSelectCollectionView.setSelectedColor(color: color)
    }
    func hide(animation: Bool = true) {
        hideAnimation(animation: animation)
        
        self.endEditing(true)
        
        if delegate != nil {
            let color = colorSelectCollectionView.selectedColor!
            let name = classNameTextField.text!
            let room = classRoomTextField.text!
            if name != "" {
                delegate.setSchedule(weekName: weekName, classNumber: classNumber, className: name, classRoom: room, color: color)
            }
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 1:
            classRoomTextField.becomeFirstResponder()
            break
        case 2:
            hide()
            break
        default:
            break
        }
        return true
    }

}
