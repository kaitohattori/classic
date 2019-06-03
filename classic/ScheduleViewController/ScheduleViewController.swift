//
//  ScheduleViewController.swift
//  classic
//
//  Created by kaichan on 2018/05/19.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, ScheduleManagerDelegate {
    
    @IBOutlet weak var controlViewView: ControlViewView!
    @IBOutlet weak var scheduleDotwView: ScheduleDotwView!
    @IBOutlet weak var scheduleView: ScheduleView!
    @IBOutlet weak var adMobView: AdMobView!
    
    private let scheduleDateManager: ScheduleDateManager = ScheduleDateManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classInfoData = classBox.datas
        
        controlViewView.selectState = .week
        
        scheduleDotwView.weekDays  = scheduleDateManager.getWeekDays()
        scheduleDotwView.weekDates = scheduleDateManager.getWeekDates()
        scheduleDotwView.reload()
        
        scheduleView.weekDays  = scheduleDateManager.getWeekDays()
        scheduleView.weekDates = scheduleDateManager.getWeekDates()
        scheduleView.reload()
        
        adMobView.start()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scheduleManager = ScheduleManager()
        scheduleManager.delegate = self
        
        scheduleDotwView.reload()
        scheduleView.reload()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func recievedClassScheduleFromAirDrop() {
        scheduleManager = ScheduleManager()
        scheduleManager.delegate = self
        scheduleView.reload()
    }
    
}
