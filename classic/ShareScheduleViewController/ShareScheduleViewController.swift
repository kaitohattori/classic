//
//  ShareScheduleViewController.swift
//  classic
//
//  Created by kaichan on 2018/05/23.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class ShareScheduleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        
        if let classDataFileURL = scheduleManager.getManagementJSONFileURL() {
            showActivity(url: classDataFileURL)
        }
    }
    
    private func showActivity(url sendFileURL: URL) {
        
        let activityVC = UIActivityViewController(activityItems: [sendFileURL], applicationActivities: nil)
        
        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivityType.postToFacebook,
            UIActivityType.postToTwitter,
            UIActivityType.message,
            UIActivityType.saveToCameraRoll,
            UIActivityType.print,
            UIActivityType.copyToPasteboard
        ]
        activityVC.excludedActivityTypes = excludedActivityTypes
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
}
