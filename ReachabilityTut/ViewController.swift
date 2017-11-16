//
//  ViewController.swift
//  ReachabilityTut
//
//  Created by Miklos Kekkoi on 11/15/17.
//  Copyright © 2017 Miklos Kekkoi. All rights reserved.
//

import UIKit


class ReachabilityManager: NSObject {
    static  let shared = ReachabilityManager()
    
    // Boolean network tracking
    var isNetworkAvailable : Bool {
        return networkStatus != .none
    }
    
    // Network tracking (none, wiFi, cellular)
    var networkStatus: Reachability.Connection = .none
    
    let reachability = Reachability()
    
    // Starts monitoring network status
    func startMonitoringNetwork() {
        print("Network monitoring started")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("Unable to start notifier")
        }
    }
    
    // Stops monitoring network status
    func stopMonitoringNetwork(){
        print("Network monitoring stopped")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }
    
  
   // Fired when network status changed
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .none:
            print("Network became unreachable")
            DispatchQueue.main.async {
                self.networkStatus = .none
            }
        case .wifi:
            print("Network reachable through WiFi")
            DispatchQueue.main.async {
                self.networkStatus = .wifi
            }
            
        case .cellular:
            print("Network reachable through Cellular Data")
            DispatchQueue.main.async {
                self.networkStatus = .cellular
            }
        }
    }
    
    
 
    
}



class ViewController: UIViewController {
    
    @IBOutlet weak var connectedLabel: UILabel!
    
    let reachability = ReachabilityManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
  
    }


    @IBAction func reachableTapped(_ sender: UIButton) {
        if reachability.isNetworkAvailable  {
            connectedLabel.text = "Connected"
        } else {
            connectedLabel.text = "Not Connected"
        }
    
     
    }
    
}

