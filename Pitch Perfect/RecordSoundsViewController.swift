//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Shyam on 06/03/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: RecordSoundsViewController: UIViewController

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: Properties
    
    var audioRecorder:AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    enum RecordingState {
        case recording, notRecording
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init Setup
        configureUI(.notRecording)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Action
    
    @IBAction func recordAudio(_ sender: Any) {
        
        configureUI(.recording)
        startRecording()
    }

    @IBAction func stopRecording(_ sender: Any) {

        configureUI(.notRecording)
        stopRecording()
    }
    
    // MARK: AVAudioRecorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was not successful")
        }
    }
    
    // MARK: Helper
    
    func configureUI(_ recordingState:RecordingState) {
        switch recordingState {
        case .recording:
            
            // Enable StopRecord Button and Disable Record Button
            recordingLabel.text = "Recording in progress"
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        case .notRecording:
            
            // Enable Record Button and Disable StopRecord Button
            recordingLabel.text = "Tap to record"
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
        }
    }
    
    func startRecording() {
        
        // Create audio file Path
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        // Setup AudioSession
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.defaultToSpeaker)
        
        // Setup AudioRecorder and start recording
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecording() {
        
        // Stop Recorder and Session to Inactive
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            
            // Send Audio File URL to PlaySoundsViewController
            let playSoundsViewController = segue.destination as! PlaySoundsViewController
            let audioURL = sender as! URL
            playSoundsViewController.recordedAudioURL = audioURL
        }
    }
    
}

