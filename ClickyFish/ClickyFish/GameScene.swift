//
//  GameScene.swift
//  ClickyFish
//
//  Created by richard Haynes on 12/16/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode?
    var timerLable : SKLabelNode?
    var score : Int = 0
    class func newGameScene() -> GameScene {
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        scene.scaleMode = .aspectFill
        return scene
    }
    
    func setUpScene(){
        let topLeftInView = CGPoint(x: 20, y: 20)
        let topLeft = convertPoint(fromView: topLeftInView)
        timerLable = childNode(withName: "//timerLabel") as? SKLabelNode
        timerLable?.position = topLeft
        
        guard let view = self.view else {
            return
        }
        let topRightInView = CGPoint(x: view.bounds.maxX - 20, y: 20)
        let topRight = convertPoint(fromView: topRightInView)
        scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        scoreLabel?.position = topRight
    }
    
    func spawnFishes() {
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(spawnFish),
            SKAction.wait(forDuration: 0.5, withRange: 0.1)
        ])))
    }
    
    func spawnFish() {
        let fishIndex = Int.random(in: 0...3)
        let fish = SKSpriteNode(imageNamed: "fish\(fishIndex)")
        fish.name = "fish"
        
        let movesLeftToRight = Bool.random()
        let randomY = CGFloat.random(in: 0...size.height - fish.size.height)
        let fishY = randomY - size.height / 2 + fish.size.height / 2
        
        if movesLeftToRight {
            let fishX = -size.width / 2 - fish.size.width / 2
            fish.position = CGPoint(x: fishX, y: fishY)
        } else {
            let fishX = size.width / 2 + fish.size.width / 2
            fish.position = CGPoint(x: fishX, y: fishY)
            fish.xScale = -1
        }
        fish.zPosition = 1
        addChild(fish)
        
        let distance = size.width + fish.size.width
        let speed = CGFloat(100)
        let duration = distance / speed
        
        let directionFactor : CGFloat = movesLeftToRight ? 1 : -1
        let moveAction = SKAction.moveBy(x: distance * directionFactor, y: 0, duration: TimeInterval(duration))
        let removeAction = SKAction.removeFromParent()
        fish.run(SKAction.sequence([moveAction, removeAction]))
    }
    override func didMove(to view: SKView) {
        
        self.setUpScene()
        spawnFishes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return}
        let location = touch.location(in: self)
        let tappedNode = atPoint(location)
        
        if tappedNode.name == "fish" {
            tappedNode.removeFromParent()
            score += 5
            scoreLabel?.text = "Score: \(score)"
        }
    }
    
}
