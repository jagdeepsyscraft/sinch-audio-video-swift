//
//  MainViewController.swift
//  Sinch-Audio-Video-Swift
//
//  Created by Jagdeep Mishra on 03/03/21.
//  Copyright © 2021 Syscraft Information System. All rights reserved.
//

import UIKit
import Sinch

class MainViewController: UIViewController, SINCallClientDelegate {
    
    @IBOutlet var destination: PaddedTextField!
    @IBOutlet var callButton: UIButton!
    
    var client: SINClient {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.client!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func awakeFromNib() {
        self.client.call().delegate = self
    }
    
    @IBAction func call(_ sender: AnyObject) {
        
        let destination = self.destination.text

        if (destination != nil) && self.client.isStarted()
        {
            weak var call: SINCall? = client.call()?.callUser(withId: destination)
            performSegue(withIdentifier: "callView", sender: call)
            
        }
        
    }
    
    @IBAction func videoCall(_ sender: AnyObject) {
        
        let destination = self.destination.text
        
        if (destination != nil) && self.client.isStarted()
        {
            weak var call: SINCall? = client.call()?.callUserVideo(withId: destination)
            
            performSegue(withIdentifier: "videoCallView", sender: call)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let callViewController = segue.destination as? AudioCallViewController
        callViewController?.call = (sender as! SINCall)
    }
    
    // MARK: - SINCallClientDelegate
    
    func client(_ client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
        performSegue(withIdentifier: "callView", sender: call)
    }
    
//    func client(_ client: SINCallClient!, localNotificationForIncomingCall call: SINCall!) -> SINLocalNotification! {
//        let notification = SINLocalNotification()
//        notification.alertAction = "Answer"
//        notification.alertBody = String(format: "Incoming call from %@", arguments: [call.remoteUserId])
//        return notification
//    }
    
}
