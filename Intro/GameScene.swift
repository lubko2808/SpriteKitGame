//
//  GameScene.swift
//  Intro
//
//  Created by Lubomyr Chorniak on 27.02.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let animationManager = AnimationManager()
    
    // Variables
    var sound = true
    var gameViewControllerBridge: GameViewController!
    var moveElectricGateY = SKAction()
    var shieldBool = false
    var score = 0
    var highscore = 0
    var gameover = 0
    
    // Texture
    var bgTexture: SKTexture!
    var flyHeroTex: SKTexture!
    var runHeroTex: SKTexture!
    var coinTexture: SKTexture!
    var redCoinTexture: SKTexture!
    var coinHeroTex: SKTexture!
    var redCoinHeroTex: SKTexture!
    var electricGateTex: SKTexture!
    var deadHeroTex: SKTexture!
    var shieldTexture: SKTexture!
    var shieldItemTexture: SKTexture!
    var mineTexture1: SKTexture!
    var mineTexture2: SKTexture!
    
    
    // Emitters node
    var heroEmmiter = SKEmitterNode()
    
    // Label nodes
    lazy var tapToPlayTextLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.text = "Tap to fly!"
        label.position = CGPoint(x: frame.midX, y: frame.midY)
        label.fontSize = 50
        label.fontName = "Chalkduster"
        label.zPosition = 1
        return label
    }()
    lazy var scoreLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "Chalkduster"
        label.text = "0"
        label.fontSize = 60
        label.fontColor = .white
        label.position = CGPoint(x: frame.midX, y: frame.maxY - 80)
        label.zPosition = 1
        return label
    }()
    lazy var highscoreLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "Chalkduster"
        label.fontSize = 50
        label.fontColor = .white
        label.position = CGPoint(x: frame.maxX - 100, y: frame.maxY - 210)
        label.zPosition = 1
        label.isHidden = true
        return label
    }()
    lazy var highscoreTextLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "Chalkduster"
        label.text = "Highscore"
        label.fontSize = 30
        label.fontColor = .white
        label.position = CGPoint(x: frame.maxX - 100, y: frame.maxY - 80)
        label.zPosition = 1
        return label
    }()
    lazy var stageLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "Chalkduster"
        label.text = "Stage 1"
        label.fontSize = 30
        label.fontColor = .white
        label.position = CGPoint(x: frame.maxX - 70, y: frame.maxY - 80)
        label.zPosition = 1
        return label
    }()
    
    //Sprite Nodes
    var bg = SKSpriteNode()
    var ground = SKSpriteNode()
    var sky = SKSpriteNode()
    var hero = SKSpriteNode()
    var coin = SKSpriteNode()
    var redCoin = SKSpriteNode()
    var electricGate = SKSpriteNode()
    var shield = SKSpriteNode()
    var shieldItem = SKSpriteNode()
    var mine = SKSpriteNode()
    
    // Sprite Objects
    var bgObject = SKNode()
    var groundObject = SKNode()
    var movingObject = SKNode()
    var heroObject = SKNode()
    var heroEmmiterObject = SKNode()
    var coinObject = SKNode()
    var redCoinObject = SKNode()
    var shieldObject = SKNode()
    var shieldItemObject = SKNode()
    var labelObject = SKNode()
    
    // Bit masks
    var heroGroup: UInt32 = 0x1 << 1
    var groundGroup: UInt32 = 0x1 << 2
    var coinGroup: UInt32 = 0x1 << 3
    var redCoinGroup: UInt32 = 0x1 << 4
    var objectGroup: UInt32 = 0x1 << 5
    var shieldGroup: UInt32 = 0x1 << 6
    
    
    // Textures array for animateWithTextures
    var heroFlyTextures = [SKTexture]()
    var heroRunTextures = [SKTexture]()
    var coinTextures = [SKTexture]()
    var electricGateTextures = [SKTexture]()
    var heroDeathTextures = [SKTexture]()
    
    
    // Timers
    var timerAddCoin = Timer()
    var timerAddRedCoin = Timer()
    var timerAddElectircGate = Timer()
    var timerAddShieldItem = Timer()
    var timerAddMine = Timer()
    
    // Sounds
    var pickCoinPreload = SKAction()
    var electricGateCreatePreload = SKAction()
    var electricGateDeadPreload = SKAction()
    var shieldOnPreload = SKAction()
    var shieldOffPreload = SKAction()
    
    override func didMove(to view: SKView) {
        
        flyHeroTex = SKTexture(imageNamed: "Fly0.png")
        runHeroTex = SKTexture(imageNamed: "Run0.png")
        
        // Coin texture
        coinTexture = SKTexture(imageNamed: "coin.jpg")
        redCoinTexture = SKTexture(imageNamed: "coin.jpg")
        coinHeroTex = SKTexture(imageNamed: "Coin0.png")
        redCoinTexture = SKTexture(imageNamed: "Coin0.png")
        
        // ElectircGate texture
        electricGateTex = SKTexture(imageNamed: "ElectricGate01.png")
        
        // Shields
        shieldTexture = SKTexture(imageNamed: "shield.png")
        shieldItemTexture = SKTexture(imageNamed: "shieldItem")
        
        // Mines texture
        mineTexture1 = SKTexture(imageNamed: "mine1.png")
        mineTexture2 = SKTexture(imageNamed: "mine2.png")
        
        // Emmiters
        heroEmmiter = SKEmitterNode(fileNamed: "engine.sks")!
        
        self.physicsWorld.contactDelegate = self
        
        createObjects()
        
        if UserDefaults.standard.object(forKey: "UserHighscore") != nil {
            highscore = UserDefaults.standard.object(forKey: "UserHighscore") as! Int
            print(highscore)
            highscoreLabel.text = "\(highscore)"
        }
        
        if gameover == 0 {
            createGame()
        }

        pickCoinPreload = SKAction.playSoundFileNamed("pickCoin.mp3", waitForCompletion: false)
        electricGateCreatePreload = SKAction.playSoundFileNamed("electricCreate.wav", waitForCompletion: false)
        electricGateDeadPreload = SKAction.playSoundFileNamed("electricDead.mp3", waitForCompletion: false)
        shieldOnPreload = SKAction.playSoundFileNamed("shieldOn.mp3", waitForCompletion: false)
        shieldOffPreload = SKAction.playSoundFileNamed("shieldOff.mp3", waitForCompletion: false)

    }
    
    private func createObjects() {
        self.addChild(bgObject)
        self.addChild(groundObject)
        self.addChild(movingObject)
        self.addChild(heroObject)
        self.addChild(heroEmmiterObject)
        self.addChild(coinObject)
        self.addChild(redCoinObject)
        self.addChild(shieldObject)
        self.addChild(shieldItemObject)
        self.addChild(labelObject)
    }
    
    private func createGame() {
        createBg()
        createGround()
        createSky()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.createHero()
            self.createHeroEmmiter()
            self.setTimer()
            self.addElectricGate()
        }
        self.addChild(tapToPlayTextLabel)
        self.addChild(scoreLabel)
        self.addChild(stageLabel)
        highscoreTextLabel.isHidden = true
        
        gameViewControllerBridge.reloadGameButton.isHidden = true
        
        if labelObject.children.count != 0 {
            labelObject.removeAllChildren()
        }
    }
    
    private func createBg() {
        bgTexture = SKTexture(imageNamed: "bg01.png")
        
        let moveBg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 3)
        let replaceBg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        let moveBgForever = SKAction.repeatForever(SKAction.sequence([moveBg, replaceBg]))
        
        for i in 0..<3 {
            bg = SKSpriteNode(texture: bgTexture)
            
//            bg.position = CGPoint(x: size.width / 4 + bgTexture.size().width * CGFloat(i), y: size.height / 2.0)
            bg.position = CGPoint(x: bgTexture.size().width * CGFloat(i), y: size.height / 2.0)

            bg.size.height = self.frame.height
            bg.run(moveBgForever)
            bg.zPosition = -1
            
            bgObject.addChild(bg)
        }
    }
    
    private func createGround() {
        ground = SKSpriteNode()
        ground.position = CGPoint.zero
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: self.frame.height / 4 + self.frame.height / 8))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = groundGroup
        ground.zPosition = 1
        groundObject.addChild(ground)
    }
    
    private func createSky() {
        sky = SKSpriteNode()
        sky.position = CGPoint(x: 0, y: self.frame.maxY)
        sky.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: 1))
        sky.physicsBody?.isDynamic = false
        sky.zPosition = 1
        movingObject.addChild(sky)
    }
    
    private func addHero(heroNode: SKSpriteNode, at position: CGPoint) {
        hero = SKSpriteNode(texture: flyHeroTex)
        
        // Animation hero
        heroFlyTextures = SKTexture.heroFlyTextures
        
        let heroFlyAnimation = SKAction.animate(with: heroFlyTextures, timePerFrame: 0.1)
        let flyHero = SKAction.repeatForever(heroFlyAnimation)
        hero.run(flyHero)
        
        hero.position = position
        hero.size = CGSize(width: 84, height: 120)
        
        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hero.size.width - 40, height: hero.size.height - 30))
        hero.physicsBody?.categoryBitMask = heroGroup
        hero.physicsBody?.contactTestBitMask = groundGroup | coinGroup | redCoinGroup | objectGroup | shieldGroup
        hero.physicsBody?.collisionBitMask = groundGroup
 
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.allowsRotation = false
        hero.zPosition = 1
        
        heroObject.addChild(hero)
    }
    
    private func createHero() {
        addHero(heroNode: hero, at: CGPoint(x: self.size.width / 4, y: flyHeroTex.size().height + 100))
    }
    
    private func createHeroEmmiter() {
        heroEmmiter = SKEmitterNode(fileNamed: "engine.sks")!
        heroEmmiterObject.zPosition = 1
        heroEmmiterObject.addChild(heroEmmiter)
    }
    
    @objc private func addCoin() {
        coin = SKSpriteNode(texture: coinTexture)
        let coinAnimation = SKAction.animate(with: SKTexture.coinTextures, timePerFrame: 0.1)
        let coinHero = SKAction.repeatForever(coinAnimation)
        coin.run(coinHero)
        
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4
        coin.size = CGSize(width: 40, height: 40)
        coin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: coin.size.width - 20, height: coin.size.height - 20))
        coin.physicsBody?.restitution = 0
        coin.position = CGPoint(x: self.size.width + 50, y: coinTexture.size().height + 90 + pipeOffset)
        
        let moveCoin = SKAction.moveBy(x: -self.frame.width * 2, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        let coinMoveBgForever = SKAction.repeatForever(.sequence([moveCoin, removeAction]))
        coin.run(coinMoveBgForever)
        
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.categoryBitMask = coinGroup
        coin.zPosition = 1
        coinObject.addChild(coin)
    }
    
    @objc private func addRedCoin() {
        redCoin = SKSpriteNode(texture: redCoinTexture)
        let redCoinAnimation = SKAction.animate(with: SKTexture.coinTextures, timePerFrame: 0.1)
        let redCoinHero = SKAction.repeatForever(redCoinAnimation)
        redCoin.run(redCoinHero)
        
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4
        redCoin.size = CGSize(width: 40, height: 40)
        redCoin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: redCoin.size.width - 10, height: redCoin.size.height - 10))
        redCoin.physicsBody?.restitution = 0
        redCoin.position = CGPoint(x: self.size.width + 50, y: redCoinTexture.size().height + 90 + pipeOffset)
        
        let moveCoin = SKAction.moveBy(x: -self.frame.width * 2, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        let coinMoveBgForever = SKAction.repeatForever(.sequence([moveCoin, removeAction]))
        redCoin.run(coinMoveBgForever)
        animationManager.scaleZdirection(sprite: redCoin)
        animationManager.redColorAnimation(sprite: redCoin, duration: 0.5)
        
        redCoin.setScale(1.3)
        redCoin.physicsBody?.isDynamic = false
        redCoin.physicsBody?.categoryBitMask = redCoinGroup
        redCoin.zPosition = 1
        redCoinObject.addChild(redCoin)
    }
    
    @objc private func addElectricGate() {
        if sound == true {
            run(electricGateCreatePreload)
        }
        
        electricGate = SKSpriteNode(texture: electricGateTex)
        let electricGateAnimation = SKAction.repeatForever(SKAction.animate(with: SKTexture.electricGateTextures, timePerFrame: 0.1))
        electricGate.run(electricGateAnimation)
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 5)
        let randomPosition = arc4random() % 2
        let pipeOffset = self.frame.size.height / 4 + 30 - CGFloat(movementAmount)
        
        if randomPosition == 0 {
            electricGate.position = CGPoint(x: self.size.width + 50, y: electricGateTex.size().height / 2 + 90 + pipeOffset)
        } else {
            electricGate.position = CGPoint(x: self.size.width + 50, y: self.frame.size.height - electricGateTex.size().height / 2 - 90 - pipeOffset)
        }
        electricGate.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: electricGate.size.width - 40, height: electricGate.size.height - 20))

        // Rotate
        electricGate.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.electricGate.run(SKAction.rotate(byAngle: CGFloat(Float.pi * 2), duration: 0.5))
            
        }, SKAction.wait(forDuration: 20.0)])))
        
        // Move
        let moveAction = SKAction.moveBy(x: -self.frame.width - 300, y: 0, duration: 6)
        electricGate.run(moveAction)

        // Scale
        var scale: CGFloat = 0.3
        
        let scaleRandom = arc4random() % UInt32(5)
        if scaleRandom == 1 { scale = 0.9 }
        else if scaleRandom == 2 { scale = 0.6 }
        else if scaleRandom == 3 { scale = 0.8 }
        else if scaleRandom == 4 { scale = 0.7 }
        else if scaleRandom == 0 { scale = 1.0 }
        electricGate.setScale(scale)
        
        let movementRandom = arc4random() % 9
        if movementRandom == 0 {
            moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 + 220, duration: 4)
        } else if movementRandom == 1 {
            moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 - 220, duration: 5)
        } else if movementRandom == 2 {
            moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 - 150, duration: 4)
        } else if movementRandom == 3 {
            moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 + 150, duration: 5)
        } else if movementRandom == 4 {
            moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 + 50, duration: 4)
        } else if movementRandom == 5 {
            moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 - 50, duration: 5)
        } else {
            moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2, duration: 4)
        }
        
        electricGate.run(moveElectricGateY)
        
        
        electricGate.physicsBody?.restitution = 0
        electricGate.physicsBody?.isDynamic = false
        electricGate.physicsBody?.categoryBitMask = objectGroup
        electricGate.zPosition = 1
        movingObject.addChild(electricGate)
        
    }
    
    @objc private func addMine() {
        mine = SKSpriteNode(texture: mineTexture1)
        let minesRandom = arc4random() % UInt32(2)
        if minesRandom == 0 {
            mine = SKSpriteNode(texture: mineTexture1)
        } else {
            mine = SKSpriteNode(texture: mineTexture2)
        }
        
        mine.size = CGSize(width: 70, height: 62)
        mine.position = CGPoint(x: self.frame.size.width + 150, y: self.frame.size.height / 4 - self.frame.size.height / 24)
        
        let moveMineX = SKAction.moveTo(x: -self.frame.size.width / 4, duration: 3)
        mine.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: mine.size.width - 40, height: mine.size.height - 30))
        mine.physicsBody?.categoryBitMask = objectGroup
        mine.physicsBody?.isDynamic = false
        
        let removeAction = SKAction.removeFromParent()
        let mineMovement = SKAction.repeatForever(.sequence([moveMineX, removeAction]))
        
        animationManager.rotate(sprite: mine)
        
        mine.run(mineMovement)
        mine.zPosition = 1
        movingObject.addChild(mine)
        
    }
    
    func addShield() {
        print("addShield")
        shield = SKSpriteNode(texture: shieldTexture)
        if sound == true { run(shieldOnPreload) }
        shield.zPosition = 1
        shieldObject.addChild(shield)
        
    }
    
    @objc private func addShieldItem() {
        shieldItem = SKSpriteNode(texture: shieldItemTexture)
        
        let movementAmount = arc4random() % UInt32(frame.size.height / 2)
        let pipeOffset = CGFloat(movementAmount) - frame.size.height / 4
        shieldItem.position = CGPoint(x: self.size.width + 50, y: shieldTexture.size().height + self.size.height / 2 + pipeOffset)
        shieldItem.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shieldItem.size.width - 20, height: shieldItem.size.height - 20))
        shieldItem.physicsBody?.restitution = 0
        
        let moveShield = SKAction.moveBy(x: -self.frame.width * 2, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        shieldItem.run(.repeatForever(.sequence([moveShield, removeAction])))
        
        animationManager.scaleZdirection(sprite: shieldItem)
        shieldItem.setScale(1.1)
        
        shieldItem.physicsBody?.isDynamic = false
        shieldItem.physicsBody?.categoryBitMask = shieldGroup
        shieldItem.zPosition = 1
        shieldObject.addChild(shieldItem)
    }
    
    private func setTimer() {
        timerAddCoin.invalidate()
        timerAddRedCoin.invalidate()
        timerAddElectircGate.invalidate()
        timerAddMine.invalidate()
        timerAddShieldItem.invalidate()
        
        
        timerAddCoin = Timer.scheduledTimer(timeInterval: 2.64, target: self, selector: #selector(addCoin), userInfo: nil, repeats: true)
        timerAddRedCoin = Timer.scheduledTimer(timeInterval: 8.64, target: self, selector: #selector(addRedCoin), userInfo: nil, repeats: true)
        timerAddElectircGate = Timer.scheduledTimer(timeInterval: 5.2, target: self, selector: #selector(addElectricGate), userInfo: nil, repeats: true)
        timerAddMine = Timer.scheduledTimer(timeInterval: 4.2, target: self, selector: #selector(addMine), userInfo: nil, repeats: true)
        timerAddShieldItem = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addShieldItem), userInfo: nil, repeats: true)
    }
    
    func stopGame() {
        coinObject.speed = 0
        movingObject.speed = 0
        redCoinObject.speed = 0
        heroObject.speed = 0
    }
    
    func reloadGame() {
        if sound == true {
            SKTAudio.sharedInstance().resumeBackgroundMusic()
        }
        
        coinObject.removeAllChildren()
        redCoinObject.removeAllChildren()
        
        stageLabel.text = "Stage 1"
        gameover = 0
        scene?.isPaused = false
        
        if labelObject.children.count != 0 {
            print("labelObject.removeAllChildren")
            labelObject.removeAllChildren()
        }
        
        movingObject.removeAllChildren()
        heroObject.removeAllChildren()
        
        coinObject.speed = 1
        heroObject.speed = 1
        movingObject.speed = 1
        self.speed = 1
        
        createGround()
        createSky()
        createHero()
        createHeroEmmiter()
        
        score = 0
        scoreLabel.text = "0"
        stageLabel.isHidden = false
        highscoreTextLabel.isHidden = true
        highscoreLabel.isHidden = true
//        labelObject.addChild(highscoreLabel)
        
        [timerAddCoin, timerAddRedCoin, timerAddElectircGate, timerAddMine, timerAddShieldItem].forEach { $0.invalidate() }
  
        setTimer()
    }
    
    override func didFinishUpdate() {
        heroEmmiter.position = hero.position - CGPoint(x: 28, y: 23)
        shield.position = hero.position
 
    }
    
    
}
 
  
