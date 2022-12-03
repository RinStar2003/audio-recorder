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
    
    var numberOfRecordes = 0
    
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
        
        // Check if we have an active recorder
        if audioRecorder == nil {
            
            numberOfRecordes += 1
            let fileName = getDirectory().appendingPathComponent("\(numberOfRecordes).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // Start Audio Recording
            
            do {
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                buttonLabel.setTitle("Stop Recording", for: .normal)
            } catch {
                displayAlert(title: "Error", message: "Cannot start the recording")
            }
        } else {
            // Stop the recording
            
            audioRecorder.stop()
            audioRecorder = nil
            
            buttonLabel.setTitle("Start Recording", for: .normal)
        }
    }
    
    
    // MARK: FUNCTIONS
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let documentsDirectory = paths[0]
        
        return documentsDirectory
    }
    
        // Display Alert
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

