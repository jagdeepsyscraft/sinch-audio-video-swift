//
//  ViewController.swift
//  Sinch-Audio-Video-Swift
//
//  Created by Jagdeep Mishra on 03/03/21.
//  Copyright © 2021 Syscraft Information System. All rights reserved.
//

import UIKit
import Sinch

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.becomeFirstResponder()
    }
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var callStatus: UILabel!
    
    @IBAction func onLoginButtonPressed(_ sender: Any) {
        print("Login")
        
        if name.text?.count == 0 {
            return
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("UserDidLoginNotification"), object: nil, userInfo: ["userId": name.text!])
        print("Sent notification")
        performSegue(withIdentifier: "mainView", sender: nil)
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If a remote notification was received which led to the application being started, the may have a transition from
        // the login view controller directly to an incoming call view controller.
        if (segue.identifier == "callView")
        {
            let callViewController = segue.destination as? AudioCallViewController
            callViewController?.call = sender as! SINCall
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

