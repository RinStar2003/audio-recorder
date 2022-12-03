//
//  ViewController.swift
//  AudioRecorder
//
//  Created by мас on 03.12.2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet var buttonLabel: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up session
        recordingSession = AVAudioSession.sharedInstance()
        
        AVAudioSession.sharedInstance().requestRecordPermission { hasPermission in
            if hasPermission {
                print("accepted")
            } else {
                print("denined")
            }
        }
    }
    
    
    @IBAction func recordingPressed(_ sender: UIButton) {
    
        
        
    }
    
    
    // MARK: FUNCTIONS
    
    func getDirectory() -> URL {
        let paths = File
        
        return
    }
    
    
}

