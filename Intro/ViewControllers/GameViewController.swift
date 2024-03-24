//
//  GameViewController.swift
//  Intro
//
//  Created by Lubomyr Chorniak on 27.02.2024.
//

import UIKit
import SpriteKit
import Combine

class GameViewController: UIViewController {
    
    var scene = GameScene(size: CGSize(width: 1024, height: 768))
    let textureAtlas = SKTextureAtlas(named: "scene.atlas")

    @IBOutlet weak var reloadGameButton: UIButton!
    @IBOutlet weak var loadingView: UIView!
    
    var subs = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden = false
        reloadGameButton.isHidden = true
        
        if let view = self.view as! SKView? {
            scene.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            scene.scaleMode = .resizeFill
            scene.showReloadGameButtonSubject
                .sink { showReloadGameButton in
                    self.reloadGameButton.isHidden = showReloadGameButton
                }
                .store(in: &subs)
            
            textureAtlas.preload {
                DispatchQueue.main.async {
                    self.loadingView.isHidden = true
                    view.presentScene(self.scene)
                }
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }
    
    @IBAction func onReloadGameButtonTapped(_ sender: UIButton) {
        scene.reloadGame()
        scene.run(.playSoundFileNamed("button_press", waitForCompletion: false))
        reloadGameButton.isHidden = true
    }
    

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
