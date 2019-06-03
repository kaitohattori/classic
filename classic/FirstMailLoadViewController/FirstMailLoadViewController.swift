//
//  FirstMailLoadViewController.swift
//  classic
//
//  Created by kaichan on 2018/05/05.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class FirstMailLoadViewController: UIViewController, GetMailManagerDelegate {
    
    private let getMailManager = GetMailManager()
    
    @IBOutlet weak var loadImageView: UIImageView!
    @IBOutlet weak var loadStateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStateLabel.text = "Preparing"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.startLoading()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimation()
    }
    
    private func startLoading() {
        loadStateLabel.text = "Loading"
        
        getMailManager.delegate = self
        getMailManager.getMail()
    }
    
    private func stopLoading() {
        loadStateLabel.text = "will be completed soon"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.stopAnimation()
            
            // Taptic Engine
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
            
            // 画面遷移
            self.dismiss(animated: true, completion: nil)
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "isLoadMail")
    }
    
    private func startAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        rotationAnimation.toValue = CGFloat.pi * -2
        rotationAnimation.duration = 0.9
        rotationAnimation.repeatCount = .infinity
        loadImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    private func stopAnimation() {
        loadImageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    func getMailRequestSuccess() { stopLoading() }
    func getMailRequestError() { stopLoading() }
    
}
