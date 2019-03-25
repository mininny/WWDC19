//
//  ARCardViewController.swift
//  PlaygroundBook
//
//  Created by Minhyuk Kim on 25/03/2019.
//

import ARKit
import UIKit
import PlaygroundSupport
import AVFoundation

@available(iOS 11.0, *)
public class ARCardViewController: UIViewController {
    
    var sceneView = ARSCNView()
    
    var player: AVAudioPlayer?
    var planeNode: SCNNode? = nil
    var currentCameraPosition = SCNVector3()
    override public func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        sceneView = ARSCNView(frame: view.frame)
        self.view.addSubview(self.sceneView)
        self.sceneView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.sceneView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.sceneView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.sceneView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        let scene = SCNScene()
        sceneView.scene = scene
    
        sceneView.autoenablesDefaultLighting = true
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -70).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(createCard), for: .touchUpInside)
        
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func createCard(){
        let skScene = SKScene(size: CGSize(width: 400, height: 400))
        skScene.backgroundColor = UIColor.clear
        
        let rectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 400, height: 400), cornerRadius: 2.5)
        rectangle.fillColor = .white
        
        let labelNode = SKLabelNode(text: "There are many ways to save the earth!\n 1. Properly recycle and dispose E-Wastes\n 2. Maintain your electronic devices\n 3. Buy well rated electronics that consum less energy\n 4. Rent and Fix equipments instead of buying\n 5. Spread the world to others!")
        labelNode.numberOfLines = 6
        labelNode.fontSize = 15
        labelNode.fontColor = .black
        
        labelNode.position = CGPoint(x:200,y:200)
        
        skScene.addChild(rectangle)
        skScene.addChild(labelNode)
        
        let plane = SCNPlane(width: 0.1, height: 0.2)
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        material.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        plane.materials = [material]
        let node = SCNNode(geometry: plane)
        
        let recycleParticle = SCNParticleSystem(named: "recycleSceneEmitter.scnp", inDirectory: nil)!
        node.addParticleSystem(recycleParticle)
        
        
        let referenceNodeTransform = matrix_float4x4(sceneView.pointOfView!.transform)
        
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.x = 0
        translationMatrix.columns.3.y = 0
        translationMatrix.columns.3.z = -0.25
        
        
        let updatedTransform = matrix_multiply(referenceNodeTransform, translationMatrix)
        node.transform = SCNMatrix4(updatedTransform)
        
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Do something with the new transform
        let currentTransform = frame.camera.transform
        let newPosition = SCNVector3(currentTransform.columns.3.x, currentTransform.columns.3.y, currentTransform.columns.3.z)
        currentCameraPosition = newPosition
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
extension ARCardViewController : ARSCNViewDelegate {

    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else{return}
        if self.planeNode == nil{
            let planeNode = createFloorNode(anchor: planeAnchor)
            node.addChildNode(planeNode)
            self.planeNode = planeNode
            
            let tree = SCNScene(named: "tree.scn")!.rootNode.childNodes
            for treeNode in tree{
                treeNode.position = SCNVector3(0, 0, 0)
                treeNode.scale = SCNVector3(0.02, 0.02, 0.02)
                treeNode.eulerAngles = SCNVector3(-Double.pi/2, 0, Double.pi)
                self.planeNode?.addChildNode(treeNode)
            }
        }
    }
    
    func createFloorNode(anchor:ARPlaneAnchor) ->SCNNode{
        let floorNode = SCNNode(geometry: SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z)))
        floorNode.position = SCNVector3(anchor.center.x,0,anchor.center.z)
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        floorNode.geometry?.firstMaterial?.isDoubleSided = true
        floorNode.eulerAngles = SCNVector3(Double.pi/2,0,0)
        return floorNode
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
