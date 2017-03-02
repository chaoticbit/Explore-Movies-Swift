//
//  InternetConnectivity.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 3/1/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import Foundation
import UIKit
import ReachabilitySwift

class InternetConnectivity {
    static func checkInternet() -> Bool {
        
        var status: Bool = true
        
        let reachability = Reachability()
        
        reachability?.whenReachable = { _ in
            DispatchQueue.main.async {
                status = true
//                print("Reachable ", status)                
            }
        }
        
        reachability?.whenUnreachable = { _ in
            DispatchQueue.main.async {
                status = false
//                print("Unreachable ", status)
            }
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: ReachabilityChangedNotification, object: reachability)
        do{
            try reachability?.startNotifier()
        } catch {
            print("could not start notifier")
        }
        
        return status
    }
    
//    @objc func internetChanged(note: Notification) {
//        let reachability = note.object as! Reachability
//        if reachability.isReachable {
//            if reachability.isReachableViaWiFi {
//                DispatchQueue.main.async {
//                    print("Wifi")
//                }
//            } else {
//                DispatchQueue.main.async {
//                    print("Cellular")
//                }
//            }
//        } else {
//            DispatchQueue.main.async {
//                print("Unreachable")
//            }
//        }
//    }

}
