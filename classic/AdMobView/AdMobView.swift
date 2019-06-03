//
//  AdMobView.swift
//  classic
//
//  Created by kaichan on 2018/05/22.
//  Copyright © 2018 kaichan. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdMobView: UIView, GADBannerViewDelegate {
    
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
        let view = Bundle.main.loadNibNamed("AdMobView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
        view.autoLayout(to: self)
    }
    
    func start() {
        
        var bannerView: GADBannerView = GADBannerView()
        bannerView = GADBannerView(adSize:kGADAdSizeBanner)
        
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // テスト広告
        bannerView.adUnitID = config.AdUnitID
        bannerView.delegate = self
        bannerView.rootViewController = self.parentViewController()
        
        let request:GADRequest = GADRequest()
        request.testDevices = config.AdDevices
        bannerView.load(request)
        self.addSubview(bannerView)
        bannerView.autoLayout(to: self)
    }
}
