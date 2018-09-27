//
//  ViewController.swift
//  SMSDK
//
//  Created by truongtvd on 09/26/2018.
//  Copyright (c) 2018 truongtvd. All rights reserved.
//

import UIKit
import SMSDK
class ViewController: UIViewController,SMInterstitialDelegate {

    var smfull:SMInterstitial!
    override func viewDidLoad() {
        super.viewDidLoad()
        testBundle = "com.quangpd.Music022"
        smfull = SMInterstitial()
        smfull.rootViewController = self
        smfull.slider = true
        smfull.delegate = self
        smfull.load()
    }

    func interstitialLoaded(interstitial: SMInterstitial) {
        smfull.show()
    }
    
    func interstitialError() {
        print("error")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

