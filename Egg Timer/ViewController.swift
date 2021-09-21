//
//  ViewController.swift
//  Egg Timer
//
//  Created by Avani Patel on 9/18/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerProgressBar: UIProgressView!
    
    let eggTimes = ["Soft" : 300, "Medium" : 420, "Hard" : 720]
    
    var timer = Timer()
    var totalTime = 0
    var secondsPassed = 0
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        let hardness = sender.currentTitle!
        totalTime = eggTimes[hardness]!
        
        timerProgressBar.progress = 0.0
        secondsPassed = 0
        titleLabel.text = hardness
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func updateTimer(){
        if secondsPassed < totalTime {
            secondsPassed += 1
            let percentProgress = Float(secondsPassed) / Float(totalTime)
            timerProgressBar.progress = percentProgress
        } else {
            timer.invalidate()
            titleLabel.text = "DONE!"
            playSound()
        }
    }
    
}

