//
//  RecordSoundViewController.swift
//  Pitchperfect
//
//  Created by Osaro Iyoha on 14/07/2018.
//  Copyright © 2018 Osaro Iyoha. All rights reserved.
//

import UIKit
import AVFoundation

//classes in swift can only inherit from one superclass but can conform to as many protocols as possible
/*
 With iOS and Swift, the delegation design pattern is achieved by utilizing an abstraction layer called a protocol. A protocol(Like an interface in Java) defines a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality.
 */
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    //An IBOutlet (Interface Builder outlet) is a variable which is a reference to a UI component. An IBAction (Interface Builder action) is a function which is called when a specific user interaction occurs. You want work to happen when you hit a button?
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.isEnabled = false
        print("viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Will Appear Called")
    }


    @IBAction func recordAudio(_ sender: AnyObject) {
        recordingLabel.text = "Recording in Progress..."
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        recordingLabel.text = "Tap to record"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecordingSegue", sender: audioRecorder.url)
        }
        else{
            print("Recording was not Successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingSegue"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

