//
//  GameScene.swift
//  Intro
//
//  Created by Lubomyr Chorniak on 27.02.2024.
//

import SpriteKit
import Combine

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let randomizerManager = RandomizerManager.shared
    let animationManager = AnimationManager()

    var showReloadGameButtonSubject = PassthroughSubject<Bool, Never>()
    var isShieldActive = false
    var isHeroDead = false
    var score = 0
    var highscore = 0
    let operationQueue = OperationQueue()

    var heroEmmiter = SKEmitterNode()
    
    var hero = SKSpriteNode()
    let heroShield = SKSpriteNode(texture: SKTexture(imageNamed: "shield.png"))
    
    var background = SKNode()
        
    lazy var tapToPlayTextLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.text = "Tap to fly!"
        label.position = CGPoint(x: frame.midX, y: frame.midY)
        label.fontSize = 50
        label.fontName = "Chalkduster"
        return label
    }()
    lazy var scoreLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "Chalkduster"
        label.text = "0"
        label.fontSize = 60
        label.fontColor = .white
        label.position = CGPoint(x: frame.midX, y: frame.maxY - 80)
        return label
    }()
    lazy var highscoreLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "Chalkduster"
        label.fontSize = 50
        label.fontColor = .white
        label.position = CGPoint(x: frame.maxX - 100, y: frame.maxY - 210)
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
        return label
    }()
    
    override func didMove(to view: SKView) {
        operationQueue.qualityOfService = .userInteractive
        operationQueue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
        self.physicsWorld.contactDelegate = self
               
        self.addChild(background)
        
        if UserDefaults.standard.object(forKey: "UserHighscore") != nil {
            highscore = UserDefaults.standard.object(forKey: "UserHighscore") as! Int
            highscoreLabel.text = "\(highscore)"
        }
        
        createGame()
    }
 
    private func createGame() {
        createBg()
        createGround()
        createSky()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.addHero()
            self.createHeroEmmiter()
            self.setNodeGenerators()
        }
        
        [tapToPlayTextLabel, scoreLabel, highscoreLabel, highscoreTextLabel].forEach { self.addChild($0) }

        highscoreTextLabel.isHidden = true
        
        showReloadGameButtonSubject.send(true)
    }
    
    private func createBg() {
        let bgTexture = SKTexture(imageNamed: "bg01.png")
        
        let moveBg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 3)
        let replaceBg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        let moveBgForever = SKAction.repeatForever(SKAction.sequence([moveBg, replaceBg]))
        
        for i in 0..<4 {
            let bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width * CGFloat(i), y: size.height / 2.0)
            bg.size.height = self.height
            bg.run(moveBgForever)
            bg.zPosition = -1
            background.addChild(bg)
        }
        
    }
        
    private func createGround() {
        let ground = SKSpriteNode()
        ground.position = CGPoint.zero
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.width,
                                                               height: self.height * Constants.groundPortionOfBg * 2))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = CollisionType.groundGroup.rawValue
        self.addChild(ground)
    }
    
    private func createSky() {
        let sky = SKSpriteNode()
        sky.position = CGPoint(x: 0, y: self.frame.maxY)
        sky.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.width, height: 1))
        sky.physicsBody?.isDynamic = false
        self.addChild(sky)
    }
    
    private func addHero() {
        hero = SKSpriteNode(texture: SKTexture(imageNamed: "Run0.png"))
        
        let heroFlyAnimation = SKAction.animate(with: SKTexture.heroFlyTextures, timePerFrame: 0.1)
        hero.run(.repeatForever(heroFlyAnimation))
        
        hero.position = CGPoint(x: self.width / 4, y: self.height / 2)
        hero.size = CGSize(width: 85, height: 120)
        
        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hero.size.width - 40, height: hero.size.height - 30))
        hero.physicsBody?.categoryBitMask = CollisionType.heroGroup.rawValue
        hero.physicsBody?.contactTestBitMask = CollisionType.groundGroup.rawValue | CollisionType.coinGroup.rawValue | CollisionType.redCoinGroup.rawValue | CollisionType.obstacleGroup.rawValue | CollisionType.shieldGroup.rawValue
        hero.physicsBody?.collisionBitMask = CollisionType.groundGroup.rawValue
 
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.allowsRotation = false
        self.addChild(hero)
    }
    
    private func createHeroEmmiter() {
        guard let heroEmmiter = SKEmitterNode(fileNamed: "engine.sks") else { return }
        self.heroEmmiter = heroEmmiter
        hero.addChild(heroEmmiter)
    }
    
    @objc private func addCoin() {
        let coin = SKSpriteNode(texture: SKTexture(imageNamed: "coin.jpg"))
        coin.name = NodeType.coin.rawValue
        let coinAnimation = SKAction.animate(with: SKTexture.coinTextures, timePerFrame: 0.1)
        coin.run(.repeatForever(coinAnimation))
        
        coin.size = CGSize(width: 40, height: 40)
        coin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: coin.size.width - 20, height: coin.size.height - 20))
        coin.physicsBody?.restitution = 0
        coin.position = randomizerManager.generateNodePisition(on: self.size, nodeSize: coin.size)
        
        coin.run(SKAction.moveNodeBehindTheScene(sceneWidth: self.size.width, speed: 400))
        
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.categoryBitMask = CollisionType.coinGroup.rawValue
        self.addChild(coin)
    }
    
    @objc private func addRedCoin() {
        let redCoin = SKSpriteNode(texture: SKTexture(imageNamed: "coin.jpg"))
        redCoin.name = NodeType.redCoin.rawValue
        let redCoinAnimation = SKAction.animate(with: SKTexture.coinTextures, timePerFrame: 0.1)
        redCoin.run(.repeatForever(redCoinAnimation))

        redCoin.size = CGSize(width: 40, height: 40)
        redCoin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: redCoin.size.width - 10, height: redCoin.size.height - 10))
        redCoin.physicsBody?.restitution = 0
        redCoin.position = randomizerManager.generateNodePisition(on: self.size, nodeSize: redCoin.size)
        
        let coinMovement = SKAction.moveBy(x: -self.frame.width * 2, y: 0, duration: 5)
        redCoin.run(.repeatForever(.sequence([coinMovement, .removeFromParent()])))
        animationManager.scaleZdirection(sprite: redCoin)
        animationManager.redColorAnimation(sprite: redCoin, duration: 0.5)
        
        redCoin.setScale(1.3)
        redCoin.physicsBody?.isDynamic = false
        redCoin.physicsBody?.categoryBitMask = CollisionType.redCoinGroup.rawValue
        self.addChild(redCoin)
    }
    
    @objc private func addElectricGate() {
        run(SKAction.electricGateCreationSound)
        
        let electricGate = SKSpriteNode(texture: SKTexture(imageNamed: "ElectricGate01.png"))
        electricGate.name = NodeType.electricGate.rawValue
        let electricGateAnimation = SKAction.repeatForever(SKAction.animate(with: SKTexture.electricGateTextures, timePerFrame: 0.1))
        electricGate.run(electricGateAnimation)

        randomizerManager.generateNodePositionAndMovement(on: self.size, node: electricGate)
        electricGate.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: electricGate.size.width - 20, height: electricGate.size.height))
        // Rotate
        let rotationAction = SKAction.run {
            electricGate.run(SKAction.rotate(byAngle: CGFloat(Float.pi * 2), duration: 0.5))
        }
        electricGate.run(SKAction.repeatForever(SKAction.sequence([rotationAction, SKAction.wait(forDuration: 20.0)])))
 
        electricGate.run(SKAction.moveNodeBehindTheScene(sceneWidth: self.size.width, speed: 220))

        electricGate.setScale(randomizerManager.generateScale())

        electricGate.physicsBody?.restitution = 0
        electricGate.physicsBody?.isDynamic = false
        electricGate.physicsBody?.categoryBitMask = CollisionType.obstacleGroup.rawValue
        self.addChild(electricGate)
        
    }
    
    @objc private func addMine() {
        let mine1Texture = SKTexture(imageNamed: "mine1.png")
        let mine2Texture = SKTexture(imageNamed: "mine2.png")
        let mine = Bool.random() == true ? SKSpriteNode(texture: mine1Texture) : SKSpriteNode(texture: mine2Texture)
        mine.name = NodeType.mine.rawValue
        mine.size = CGSize(width: 70, height: 60)
        mine.position = CGPoint(x: self.frame.size.width + 150, y: self.height *  Constants.groundPortionOfBg + mine.size.height / 2)

        mine.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: mine.size.width - 40, height: mine.size.height - 30))
        mine.physicsBody?.categoryBitMask = CollisionType.obstacleGroup.rawValue
        mine.physicsBody?.isDynamic = false
        
        animationManager.rotate(sprite: mine)
        mine.run(SKAction.moveNodeBehindTheScene(sceneWidth: self.size.width, speed: 600))
        self.addChild(mine)
    }
    
    func addShield() {
        heroShield.name = NodeType.shield.rawValue
        run(SKAction.shieldOnSound)
        hero.addChild(heroShield)
    }
    
    @objc private func addShieldItem() {
        let shieldItem = SKSpriteNode(texture: SKTexture(imageNamed: "shieldItem"))
        shieldItem.name = NodeType.shieldItem.rawValue
        shieldItem.position = randomizerManager.generateNodePisition(on: self.size, nodeSize: shieldItem.size)
        shieldItem.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shieldItem.size.width - 20, height: shieldItem.size.height - 20))
        shieldItem.physicsBody?.restitution = 0

        shieldItem.run(SKAction.moveNodeBehindTheScene(sceneWidth: self.size.width, speed: 500))
        
        animationManager.scaleZdirection(sprite: shieldItem)
        shieldItem.setScale(1.1)
        
        shieldItem.physicsBody?.isDynamic = false
        shieldItem.physicsBody?.categoryBitMask = CollisionType.shieldGroup.rawValue
        self.addChild(shieldItem)
    }
    
    
    private func setNodeGenerators() {
        
        let coinOperation = NodeOperation(nodeGenerator: self.addCoin, intervalRange: 2...5)
        let redCoinOperation = NodeOperation(nodeGenerator: self.addRedCoin, intervalRange: 4...9)
        let electricGateOperation = NodeOperation(nodeGenerator: self.addElectricGate, intervalRange: 4...7)
        let mineOperation = NodeOperation(nodeGenerator: self.addMine, intervalRange: 3...6)
        let shieldItemOperation = NodeOperation(nodeGenerator: self.addShieldItem, intervalRange: 7...11)
        [coinOperation, redCoinOperation, electricGateOperation, mineOperation, shieldItemOperation].forEach {
            operationQueue.addOperation($0)
        }

    }
    

    func reloadGame() {
        SKTAudio.sharedInstance().resumeBackgroundMusic()

        isHeroDead = false
        
        background.speed = 1
        addHero()
        createHeroEmmiter()
        
        score = 0
        scoreLabel.text = "0"
        highscoreTextLabel.isHidden = true
        highscoreLabel.isHidden = true

        setNodeGenerators()
    }
    
    override func didFinishUpdate() {
        heroEmmiter.position = CGPoint(x: -28, y: -23)
    }
    
    
}
 
