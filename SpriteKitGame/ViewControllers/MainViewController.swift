//
//  MainViewController.swift
//  Intro
//
//  Created by Lubomyr Chorniak on 20.03.2024.
//

import UIKit
import SpriteKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKTAudio.sharedInstance().playBackgroundMusic(filename: "Latin_Industries.mp3")
    }
    
    @IBAction func onPlayGameButtonTapped(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect(filename: "button_press.wav")
        guard let storyboard = storyboard else { return }
        let gameViewController = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        navigationController?.pushViewController(gameViewController, animated: true)
        
    } 
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
}
