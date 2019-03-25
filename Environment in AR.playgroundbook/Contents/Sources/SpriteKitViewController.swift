//
//  SpriteKitViewController.swift
//  PlaygroundBook
//
//  Created by Minhyuk Kim on 21/03/2019.
//

import UIKit
import SpriteKit
import GameplayKit
import PlaygroundSupport
import AVFoundation

@available(iOS 11.0, *)
public class SpriteKitViewController: UIViewController {
    
    public var spriteKitViewEnabled = true
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = SKView(frame: UIScreen.main.bounds)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size: view.frame.size)
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override public var shouldAutorotate: Bool {
        return true
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override public var prefersStatusBarHidden: Bool {
        return true
    }
}

@available(iOS 11.0, *)
public class GameScene: SKScene, PlaygroundLiveViewMessageHandler{

    var enableCollision = true
    var enableEmitter = true
    var trashCount = 30
    var emitterColor : UIColor? = nil
    var appleNode = SKSpriteNode()
    var trashNodes = [SKSpriteNode]()
    var player: AVAudioPlayer?
    override public func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        for _ in 0..<trashCount{
            
            let image = UIImage(named: "trash.png")
            
            let texture = SKTexture(image: image!)
            let ball = SKSpriteNode(texture: texture)
            ball.size = CGSize(width: 148, height: 184)
            ball.position = CGPoint(x: getRandX(), y: getRandY())
            ball.physicsBody = SKPhysicsBody(texture: texture, size: ball.size)
            ball.physicsBody!.affectedByGravity = false
            ball.physicsBody!.categoryBitMask = PhysicsCategories.trashCategory
            ball.physicsBody!.contactTestBitMask = PhysicsCategories.appleCategory
            ball.physicsBody!.collisionBitMask = PhysicsCategories.appleCategory
            trashNodes.append(ball)
            self.addChild(ball)
        }
        
        let image = UIImage(named: "apple.png")
        let texture = SKTexture(image: image!)
        
        let apple = SKSpriteNode(texture: texture)
        
        apple.size = CGSize(width: 166, height: 208)
        apple.physicsBody = SKPhysicsBody(texture: texture, size: apple.size)
        apple.physicsBody!.affectedByGravity = false
        apple.physicsBody!.categoryBitMask = PhysicsCategories.appleCategory
        apple.physicsBody!.contactTestBitMask = PhysicsCategories.trashCategory
        apple.physicsBody!.collisionBitMask = PhysicsCategories.trashCategory
        
        if enableEmitter{
            let particleNode = SKEmitterNode(fileNamed: "trashSpriteEmitter.sks")!
            apple.addChild(particleNode)
        }
        
        appleNode = apple
        self.addChild(appleNode)
        
        let rotationGestureRecog = UIRotationGestureRecognizer(target: self, action: #selector(rotateAppleNode(sender:)))
        self.view?.addGestureRecognizer(rotationGestureRecog)
        
        let pinchGestureRecog = UIPinchGestureRecognizer(target: self, action: #selector(pinchAppleNode(sender:)))
        self.view?.addGestureRecognizer(pinchGestureRecog)
    }
    
    @objc func rotateAppleNode(sender: UIRotationGestureRecognizer){
        appleNode.zRotation = appleNode.zRotation - sender.rotation
        sender.rotation = 0
    }
    
    @objc func pinchAppleNode(sender: UIPinchGestureRecognizer){
        appleNode.setScale(sender.scale)
        sender.scale = 0
    }
    func resetTrashNodes(){
        for node in trashNodes{
            node.removeFromParent()
        }
        trashNodes.removeAll()
        for _ in 0..<trashCount{
            let image = UIImage(named: "trash.png")
            
            let texture = SKTexture(image: image!)
            let ball = SKSpriteNode(texture: texture)
            ball.size = CGSize(width: 148, height: 184)
            ball.position = CGPoint(x: getRandX(), y: getRandY())
            ball.physicsBody = SKPhysicsBody(texture: texture, size: ball.size)
            ball.physicsBody!.affectedByGravity = false
            ball.physicsBody!.categoryBitMask = PhysicsCategories.trashCategory
            ball.physicsBody!.contactTestBitMask = PhysicsCategories.appleCategory
            ball.physicsBody!.collisionBitMask = PhysicsCategories.appleCategory
            trashNodes.append(ball)
            self.addChild(ball)
        }
    }
    //Drag Apple Node
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    public func touchMoved(toPoint pos : CGPoint) {
        appleNode.position = pos
    }
    
    public func getRandX() -> CGFloat{
        let maxX : CGFloat = (self.scene?.frame.maxX)! - 10
        return CGFloat.random(in: 0.0...maxX)
    }
    public func getRandY() -> CGFloat{
        let maxY : CGFloat = (self.scene?.frame.maxY)! - 10
        return CGFloat.random(in: 0.0...maxY)
    }
    
    override public func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    //Plays sound with AVFoundation
    func playSound(name: String, ext: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else { return }
        
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
    
    public func receive(_ message: PlaygroundValue) {
        switch message{
        case let .dictionary(dictionary):
            guard case let .string(command)? = dictionary["Command"] else {
                return
            }
            switch command{
            case "trashCount":
                if case let PlaygroundValue.integer(message)? = dictionary["Message"]{
                    trashCount = message
                    resetTrashNodes()
                }
                break
            case "emitterColor":
                if case let PlaygroundValue.string(message)? = dictionary["Message"]{
                    emitterColor = UIColor(hexString: message)
                }
                break
            default:
                break
            }
        case let .string(text):
            switch text{
            case "enableCollision":
                enableCollision = true
                break
            case "enableEmitter":
                enableEmitter = true
                break
            default:
                break
            }
        default:
            break
        }
    }
}

@available(iOS 11.0, *)
extension GameScene: SKPhysicsContactDelegate{
    public func didBegin(_ contact: SKPhysicsContact) {
        if enableCollision{
            playSound(name: "trash", ext: "wav")
            if contact.bodyA.categoryBitMask == PhysicsCategories.trashCategory && contact.bodyB.categoryBitMask != PhysicsCategories.trashCategory{
                let emitter = SKEmitterNode(fileNamed: "trashExplosionEmitter.sks")!
                emitter.position = contact.bodyA.node!.position
                if let color = emitterColor{
                    emitter.particleColor = color
                }
                addChild(emitter)
                contact.bodyA.node?.removeFromParent()
            }else{
                if contact.bodyB.categoryBitMask == PhysicsCategories.trashCategory && contact.bodyA.categoryBitMask != PhysicsCategories.trashCategory{
                    contact.bodyB.node?.removeFromParent()
                }
            }
        }
    }
}


public struct PhysicsCategories {
    static let noCategory: UInt32 = 0
    static let allCategory: UInt32 = UInt32.max
    static let trashCategory: UInt32 = 0x1
    static let appleCategory: UInt32 = 0x1 << 2
}
