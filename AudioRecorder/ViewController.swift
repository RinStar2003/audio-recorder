//
//  ViewController.swift
//  AudioRecorder
//
//  Created by мас on 03.12.2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    @IBOutlet var myTableView: UITableView!
    
    var numberOfRecords: Int = 0
    
    @IBOutlet var buttonLabel: UIButton!
    
    @IBAction func recordingPressed(_ sender: UIButton) {
        
        // Check if we have an active recorder
        if audioRecorder == nil {
            
            numberOfRecords += 1
            let fileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // Start Audio Recording
            
            do {
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                try recordingSession.setCategory(AVAudioSession.Category.record)
                audioRecorder.record()
                
                buttonLabel.setTitle("Stop Recording", for: .normal)
            } catch {
                displayAlert(title: "Error", message: "Cannot start the recording")
            }
        } else {
            
            // Stop the recording
            do {
                audioRecorder.stop()
                audioRecorder = nil
                
                UserDefaults.standard.set(numberOfRecords, forKey: "myNumber")
                try recordingSession.setCategory(AVAudioSession.Category.playback)
                myTableView.reloadData()
                
                buttonLabel.setTitle("Start Recording", for: .normal)
            } catch {
                displayAlert(title: "Error", message: "Cannot stop the recording")
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up session
        recordingSession = AVAudioSession.sharedInstance()
        
        if let number: Int = UserDefaults.standard.object(forKey: "myNumber") as? Int {
            numberOfRecords = number
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { hasPermission in
            if hasPermission {
                print("accepted")
            } else {
                print("denined")
            }
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
    
    // MARK: - TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecords
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1)
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
        } catch {
            
        }
    }
}

