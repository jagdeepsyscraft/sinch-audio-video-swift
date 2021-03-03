//
//  VideoCallViewController.swift
//  Sinch-Audio-Video-Swift
//
//  Created by Jagdeep Mishra on 03/03/21.
//  Copyright © 2021 Syscraft Information System. All rights reserved.
//


import Foundation
import UIKit
import Sinch

enum VButtonsBar: Int {
    
    case decline
    case hangup
}

class VideoCallViewController:UIViewController,SINCallDelegate {

    @IBOutlet weak var remoteUserName: UILabel!
    @IBOutlet var callStateLabel: UILabel!
    @IBOutlet var declineButton: UIButton!
    @IBOutlet var answerButton: UIButton!
    @IBOutlet var endCallBUtton: UIButton!
   
    @IBOutlet var remoteVideoView: UIView!
    @IBOutlet var localVideoView: UIView!
    
    @IBOutlet weak var remoteVideoFullscreenGestureRecognizer: UIGestureRecognizer!
    @IBOutlet weak var localVideoFullscreenGestureRecognizer: UIGestureRecognizer!
    @IBOutlet weak var switchCameraGestureRecognizer: UIGestureRecognizer!
    @IBOutlet weak var pauseResumeVideoRecognizer: UITapGestureRecognizer!
    var videoPaused = false
    
    var durationTimer: Timer?
    var call: SINCall!
    
    var audioController:SINAudioController {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        return (appDelegate.client?.audioController())!
    }
    
    var videoController:SINVideoController {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        return (appDelegate.client?.videoController())!
    }
    
    
    // MARK: - UIViewController Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        call.delegate=self
        
        if call.direction == .incoming
        {
            setCallStatus("")
            showButtons(.decline)
            self.audioController.enableSpeaker()
            self.audioController.startPlayingSoundFile(self.pathForSound("incoming.wav"), loop: true)
        }
        else
        {
            // setCallStatus.text = "calling..."
            setCallStatus("calling.....")
            showButtons(.hangup)
            
        }
        
        self.audioController.enableSpeaker()
        self.localVideoView.addSubview(self.videoController.localView())
        self.localVideoFullscreenGestureRecognizer.require(toFail: switchCameraGestureRecognizer)
        self.localVideoFullscreenGestureRecognizer.require(toFail: pauseResumeVideoRecognizer)
        self.switchCameraGestureRecognizer.require(toFail: pauseResumeVideoRecognizer)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        remoteUserName.text = call?.remoteUserId!
    }
    
    // MARK: - Call Actions
    @IBAction func accept(_ sender: Any) {
        
        self.audioController.enableSpeaker()
        self.audioController.stopPlayingSoundFile()
        call.answer()
    }
    
    @IBAction func decline(_ sender: Any) {
        self.audioController.disableSpeaker()
        call.hangup()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hangup(_ sender: Any) {
        call.hangup()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func onDurationTimer(_ unused: Timer) {
        let duration = Int(Date().timeIntervalSince(call.details.establishedTime))
        
        DispatchQueue.main.async {
            self.setDuration(duration)
        }
        
    }
    
    @IBAction func onSwitchCameraTapped(_ sender: Any) {
        let current = videoController.captureDevicePosition
        videoController.captureDevicePosition = SINToggleCaptureDevicePosition(current)
    }

    @IBAction func onFullScreenTapped(_ sender: Any) {
        //On Tap Open localVideoView in Full Screen
    }
    
    @IBAction func onPauseResumeVideoTapped(_ sender: Any) {
        if videoPaused {
            call.resumeVideo()
            videoPaused = false
        } else {
            call.pauseVideo()
            videoPaused = true
        }
    }
    
    
    // MARK: - SINCallDelegate
    
    func callDidProgress(_ call: SINCall)
    {
        callStateLabel.text = "ringing..."
        audioController.startPlayingSoundFile(pathForSound("ringback.wav"), loop: true)
    }
    
    func callDidEstablish(_ call: SINCall)
    {
        self.remoteVideoView.isHidden = false
        startCallDurationTimerWithSelector(#selector(VideoCallViewController.onDurationTimer(_:)))
        showButtons(.hangup)
        audioController.stopPlayingSoundFile()
    }
    
    func callDidEnd(_ call: SINCall)
    {
        videoController.remoteView().removeFromSuperview()
        audioController.stopPlayingSoundFile()
        stopCallDurationTimer()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func callDidAddVideoTrack(_ call: SINCall?) {
        remoteVideoView.addSubview(videoController.remoteView())
        remoteVideoView.isHidden = true
    }
    
    func callDidPauseVideoTrack(_ call: SINCall?) {
        remoteVideoView.isHidden = true
    }
    
    func callDidResumeVideoTrack(_ call: SINCall?) {
        remoteVideoView.isHidden = false
    }
    
    // MARK: - Sounds
    func pathForSound(_ soundName: String) -> String {
        let resourcePath = Bundle.main.resourcePath! as NSString
        return resourcePath.appendingPathComponent(soundName)
    }
}


// MARK: - This extension contains UI helper methods for VideoCallViewController

extension VideoCallViewController {
    
    // MARK: - Call Status
    
    func setCallStatusText(_ text: String) {
        callStateLabel.text = text
    }
    
    func setCallStatus(_ text: String) {
        self.callStateLabel.text = text
    }
    
    // MARK: - Buttons
    
    func showButtons(_ buttons: VButtonsBar) {
        if buttons == .decline {
            answerButton.isHidden = false
            declineButton.isHidden = false
            endCallBUtton.isHidden = true
        }
        else if buttons == .hangup {
            endCallBUtton.isHidden = false
            answerButton.isHidden = true
            declineButton.isHidden = true
        }
    }
    
    // MARK: - Duration
    
    func setDuration(_ seconds: Int)
    {
        setCallStatusText(String(format: "%02d:%02d", arguments: [Int(seconds / 60), Int(seconds % 60)]))
    }
    
    @objc func internal_updateDurartion(_ timer: Timer)
    {
        
        let selector:Selector = NSSelectorFromString(timer.userInfo as! String)
        
        if self.responds(to: selector)
        {
            self.performSelector(inBackground: selector, with: timer)
        }
        
    }
    
    func startCallDurationTimerWithSelector(_ selector: Selector) {
        let selectorString  = NSStringFromSelector(selector)
        durationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(VideoCallViewController.internal_updateDurartion(_:)), userInfo: selectorString, repeats: true)
    }
    
    func stopCallDurationTimer() {
        durationTimer?.invalidate()
        durationTimer = nil
    }
    
}
