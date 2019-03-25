//
//  HelloARViewController.swift
//  Book_Sources
//
//  Created by Minhyuk Kim on 17/03/2019.
//

import UIKit
import SpriteKit
import GameplayKit
import ARKit
import PlaygroundSupport
import AVFoundation

public enum NodeType : String{
    case sphere
    case box
    case cylinder
    case cone
    case capsule
    case tube
    case trash
}

@available(iOS 11.0, *)
public class ARViewController: UIViewController {
    
    var sceneView = ARSCNView()
    var planeDetectionEnabled = false
    public var hitTestEnabled = false
    public var fullDebugEnabled = false
    var appleNodeEnabled = false
    var planeColor = #colorLiteral(red: 0, green: 0.1384256577, blue: 0.6781408091, alpha: 1)
    var label = UILabel()
    var nodeColor = #colorLiteral(red: 0, green: 0.1384256577, blue: 0.6781408091, alpha: 1)
    var nodeSize = 0.03
    var nodeType : NodeType = .sphere
    var trashNodes = [SCNNode]()
    let trashNode = SCNScene(named: "trash.scn")!.rootNode.childNodes.first!
    let appleNode = SCNScene(named: "apple.scn")!.rootNode.childNodes.first!
    var isTrashNode = false
    var innerCircle = UIView()
    var outerCircle = UIView()
    var innerCircleConstraint = NSLayoutConstraint()
    var currentCameraPosition = SCNVector3()
    var enableCollision = false
    
    var player: AVAudioPlayer?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Setting up AR View
    @available(iOS 11.0, *)
    public func setUpAR(){
        sceneView = ARSCNView(frame: view.frame)
        self.view.addSubview(self.sceneView)
        self.sceneView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.sceneView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.sceneView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.sceneView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        sceneView.delegate = self
        sceneView.showsStatistics = false
        let scene = SCNScene()
        scene.physicsWorld.contactDelegate = self
        sceneView.scene = scene
        if fullDebugEnabled{
            sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin, .showBoundingBoxes, .showWireframe, .showSkeletons, .showPhysicsFields, .showPhysicsShapes, .showCameras, .showCreases, .showLightExtents]
        }else{
            sceneView.debugOptions = [.showFeaturePoints]
        }
        
        sceneView.autoenablesDefaultLighting = true
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    //Initial Stage AR
    func showHelloLabel(){
        let text = SCNText(string: "WELCOME TO AR", extrusionDepth: 0.1)
        text.font = UIFont(name: "Arial", size: 0.3)
        
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(-1, -1, -1)
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
    
    //Stage 4-5 set up location label for SCNNodes
    func showLocationLabel(){
        label = UILabel(frame: CGRect(x: view.frame.midX, y: 50, width: 130, height: 40))
        
        let labelView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        labelView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: labelView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: labelView.centerYAnchor).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(labelView)
        labelView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        labelView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        labelView.widthAnchor.constraint(equalTo: label.widthAnchor, constant: 25).isActive = true
        labelView.heightAnchor.constraint(equalTo: label.heightAnchor, constant: 20).isActive = true
        labelView.layer.cornerRadius = 7.5
        labelView.translatesAutoresizingMaskIntoConstraints = false
        
        labelView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        
        label.isHidden = false
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
    
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if hitTestEnabled{
            if let touchLocation = touches.first?.location(in: sceneView) {
                if let hitResult = sceneView.hitTest(touchLocation, types: .featurePoint).first{
                    let node = getNode()

                    if !isTrashNode{
                        label.text = String(format: "x:%.3f, y:%.3f, z:%.3f", hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
                        label.sizeToFit()
                    }

                    if trashNodes.count > 50{
                        showTrashMessage()
                        self.send(.string("Listener"))
                    }else{
                        if isTrashNode{
                            trashNodes.append(node)
                            playSound(name: "trash", ext: "wav")
                            innerCircleConstraint.constant = CGFloat(trashNodes.count) * 4
                            innerCircle.layer.cornerRadius = CGFloat(trashNodes.count / 50) * 15
                        }
                        node.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
                        
                        playSound(name: "plop", ext: "wav")
                        sceneView.scene.rootNode.addChildNode(node)
                        label.sizeToFit()
                    }
                }
            }
        }
    }
    
    func showTrashMessage(){
        let messageView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        messageView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        
        let trashMessage = UILabel(frame: CGRect(x: 0, y: 0, width: 130, height: 50))
        trashMessage.numberOfLines = 3
        trashMessage.text = "That was 50 million tons of E-Waste, with \neach trash node being 1 million tons of E-Waste. \nA lot, right? As you can see, it's all around us!"
        trashMessage.sizeToFit()
        
        messageView.addSubview(trashMessage)
        trashMessage.translatesAutoresizingMaskIntoConstraints = false
        trashMessage.centerXAnchor.constraint(equalTo: messageView.centerXAnchor).isActive = true
        trashMessage.centerYAnchor.constraint(equalTo: messageView.centerYAnchor).isActive = true
        
        messageView.layer.cornerRadius = 10
        self.view.addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        messageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        messageView.heightAnchor.constraint(equalTo: trashMessage.heightAnchor, constant: 40).isActive = true
        messageView.widthAnchor.constraint(equalTo: trashMessage.widthAnchor, constant: 80).isActive = true
    }
    
    //Scrolling of Apple Node
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if appleNodeEnabled{
            guard let currentTouchPoint = touches.first?.location(in: self.sceneView), let hitTest = self.sceneView.hitTest(currentTouchPoint, types: .existingPlane).first else { return }
            
            
            //3. Convert To World Coordinates
            
            let worldTransform = hitTest.worldTransform
            
            //4. Set The New Position
            let newPosition = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
            
            //5. Apply To The Node
            appleNode.position = newPosition
        }
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Do something with the new transform
        let currentTransform = frame.camera.transform
        let newPosition = SCNVector3(currentTransform.columns.3.x, currentTransform.columns.3.y, currentTransform.columns.3.z)
        currentCameraPosition = newPosition
    }
    
    //Show Progress bar for Trash Node at Stage 5
    func showProgressBar(){
        outerCircle = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        innerCircle = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        outerCircle.translatesAutoresizingMaskIntoConstraints = false
        innerCircle.translatesAutoresizingMaskIntoConstraints = false
        
        outerCircle.backgroundColor = UIColor(white: 1, alpha: 0.8)
        outerCircle.layer.cornerRadius = 15
        innerCircle.backgroundColor = UIColor(hexString: "78422E")
        innerCircle.layer.cornerRadius = 0
        
        outerCircle.addSubview(innerCircle)
        
        innerCircleConstraint = NSLayoutConstraint(item: innerCircle, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        innerCircleConstraint.isActive = true
        innerCircle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        innerCircle.centerXAnchor.constraint(equalTo: outerCircle.centerXAnchor).isActive = true
        innerCircle.centerYAnchor.constraint(equalTo: outerCircle.centerYAnchor).isActive = true
        
        view.addSubview(outerCircle)
        outerCircle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        outerCircle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        outerCircle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        outerCircle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
    }

    
    func generateRandomTrash(){
        for node in trashNodes{
            node.removeFromParentNode()
        }
        trashNodes.removeAll()
        for _ in 0...20{
            let trashNode = self.trashNode.clone()
            trashNode.scale = SCNVector3(0.02, 0.02, 0.02)
            trashNode.position = currentCameraPosition + SCNVector3(x: rand(), y: -0.1, z: rand())
            trashNode.eulerAngles = SCNVector3(-Double.pi/2,0,0)
            
            if #available(iOS 12.0, *) {
                trashNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: SCNCylinder(radius: trashNode.frame.width/2, height: trashNode.frame.height), options: nil))
            } else {
                trashNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: SCNCylinder(radius: CGFloat((trashNode.geometry?.boundingBox.max.x)!/2), height: CGFloat((trashNode.geometry?.boundingBox.max.y)!)), options: nil))
            }
            trashNode.physicsBody?.isAffectedByGravity = false
            
            trashNode.physicsBody?.categoryBitMask = CollisionCategory.trashCategory.rawValue
            trashNode.physicsBody?.contactTestBitMask = CollisionCategory.appleCategory.rawValue
            trashNode.physicsBody?.collisionBitMask = CollisionCategory.appleCategory.rawValue
            
            sceneView.scene.rootNode.addChildNode(trashNode)
            trashNodes.append(trashNode)
        }
    }
    
    func rand() -> Float{
        if Float.random(in: -0.01...0.01) > 0{
            return Float.random(in: 0.0...0.2)
        }else{
            return -Float.random(in: 0.0...0.2)
        }
    }

    func getNode() -> SCNNode{
        switch nodeType{
        case .box:
            let node = SCNNode(geometry: SCNBox(width: CGFloat(nodeSize), height: CGFloat(nodeSize), length: CGFloat(nodeSize), chamferRadius: 0))
            node.geometry?.firstMaterial?.diffuse.contents = self.nodeColor
            return node
        case .sphere:
            let node = SCNNode(geometry: SCNSphere(radius: CGFloat(nodeSize)))
            node.geometry?.firstMaterial?.diffuse.contents = self.nodeColor
            return node
        case .cylinder:
            let node = SCNNode(geometry: SCNCylinder(radius: CGFloat(nodeSize), height: CGFloat(nodeSize)))
            node.geometry?.firstMaterial?.diffuse.contents = self.nodeColor
            return node
        case .cone:
            let node = SCNNode(geometry: SCNCone(topRadius: 0, bottomRadius: CGFloat(nodeSize), height: CGFloat(nodeSize)))
            node.geometry?.firstMaterial?.diffuse.contents = self.nodeColor
            return node
        case .capsule:
            let node = SCNNode(geometry: SCNCapsule(capRadius: CGFloat(nodeSize), height: CGFloat(nodeSize)))
            node.geometry?.firstMaterial?.diffuse.contents = self.nodeColor
            return node
        case .tube:
            let node = SCNNode(geometry: SCNTube(innerRadius: CGFloat(nodeSize - 0.006), outerRadius: CGFloat(nodeSize), height: CGFloat(nodeSize)))
            node.geometry?.firstMaterial?.diffuse.contents = self.nodeColor
            return node
        case .trash:
            let trashNode = self.trashNode.clone()
            trashNode.scale = SCNVector3(0.025, 0.025, 0.025)
            trashNode.eulerAngles = SCNVector3(-Double.pi/2,0,0)
            return trashNode
        }
    }
    
    // MARK: Overriden variables
    override public var shouldAutorotate: Bool {
        return true
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
}

@available(iOS 11.0, *)
extension ARViewController : PlaygroundLiveViewMessageHandler {

    open func receive(_ message: PlaygroundValue) {
        switch message{
        case let .dictionary(dictionary):
            guard case let .string(command)? = dictionary["Command"] else {
                return
            }
            switch command{
            case "planeColor":
                if case let PlaygroundValue.string(message)? = dictionary["Message"]{
                    planeColor = UIColor(hexString: message)
                }
                break
            case "nodeType":
                if case let PlaygroundValue.string(message)? = dictionary["Message"]{
                    nodeType = NodeType(rawValue: message)!
                }
                break
            case "nodeColor":
                if case let PlaygroundValue.string(message)? = dictionary["Message"]{
                    nodeColor = UIColor(hexString: message)
                }
                break
            case "nodeSize":
                if case let PlaygroundValue.floatingPoint(message)? = dictionary["Message"]{
                    nodeSize = message
                }
                break
            default:
                break
            }
        case let .string(text):
            switch text{
            case "setUpAR":
                setUpAR()
                showHelloLabel()
                break
            case "enablePlaneDetection":
                setUpAR()
                planeDetectionEnabled = true
                break
            case "enableHitTest":
                showLocationLabel()
                hitTestEnabled = true
                break
            case "enableTrashNode":
                isTrashNode = true
                showProgressBar()
                break
            case "appleNodeEnabled":
                appleNodeEnabled = true
                break
            case "createAppleNode":
                appleNode.position = SCNVector3(currentCameraPosition.x, currentCameraPosition.y + 0.1, currentCameraPosition.z)
                appleNode.scale = SCNVector3(0.02, 0.02, 0.02)
                appleNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: SCNSphere(radius: CGFloat(0.08)), options: nil))
                
                appleNode.physicsBody?.categoryBitMask = CollisionCategory.appleCategory.rawValue
                appleNode.physicsBody?.contactTestBitMask = CollisionCategory.trashCategory.rawValue
                appleNode.physicsBody?.collisionBitMask = CollisionCategory.trashCategory.rawValue
                appleNode.physicsBody?.isAffectedByGravity = false
                
                appleNode.pivot = SCNMatrix4MakeTranslation(0.5, 0.5, 0.5)
                
                appleNode.look(at: currentCameraPosition)
                
                sceneView.scene.rootNode.addChildNode(appleNode)
                break
            case "enableDragging":
                appleNodeEnabled = true
                break
            case "createRandomTrash":
                generateRandomTrash()
                break
            case "enableCollision":
                enableCollision = true
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
extension ARViewController : ARSCNViewDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else{return}
        if planeDetectionEnabled{
            let planeNode = createFloorNode(anchor: planeAnchor)
            node.addChildNode(planeNode)
        }
    }
    
    func createFloorNode(anchor:ARPlaneAnchor) ->SCNNode{
        let floorNode = SCNNode(geometry: SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z)))
        floorNode.position = SCNVector3(anchor.center.x,0,anchor.center.z)
        floorNode.geometry?.firstMaterial?.diffuse.contents = planeColor
        floorNode.geometry?.firstMaterial?.isDoubleSided = true
        floorNode.eulerAngles = SCNVector3(-Double.pi/2,0,0)
        return floorNode
    }
    
    @objc func addAnchor() {
        if let currentFrame = sceneView.session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.4
            let transform = simd_mul(currentFrame.camera.transform, translation)
            
            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            
            sceneView.session.add(anchor: anchor)
        }
    }
    
    public func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    public func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}

@available(iOS 11.0, *)
extension ARViewController: SCNPhysicsContactDelegate{
    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        playSound(name: "trash", ext: "wav")
        if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.trashCategory.rawValue{
            let emitter = SCNParticleSystem(named: "trashSceneEmitter.scnp", inDirectory: nil)!
            contact.nodeA.addParticleSystem(emitter)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 15000)) {
                contact.nodeA.removeFromParentNode()
            }
        }else{
            let emitter = SCNParticleSystem(named: "trashSceneEmitter.scnp", inDirectory: nil)!
            contact.nodeB.addParticleSystem(emitter)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 15000)) {
                contact.nodeB.removeFromParentNode()
            }
        }
    }
}
