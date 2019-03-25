
//#-hidden-code
import UIKit
import PlaygroundSupport
import SpriteKit

let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy
//
//func enableSpriteKit(){
//    proxy?.send(.string("enableSpriteKit"))
//}

//#-end-hidden-code
/*:
 # 2D World - SpriteKit
 
 In previous page, we tried how we used collision to demonstrate Apple's efforts to improve the environment. However, because valid hit points don't exist everywhere, so we have missed a few trashes.
 
 While we can't find valid feature points everywhere in our 3D world, in 2D world, we can touch and access anywhere in our screen.
 
 In this page, we will look at 2D world, SKNodes, and emitters.
 
 # SpriteKit
 SpriteKit is displayed on a [SKView](glossary://SKView) that renders a [SpriteKit scene](glossary://SKScene), then displays [SpriteKit Nodes](glossary://SKNode) from geometric shapes to images.
 
 In this page, we will again put trash nodes and apple nodes in our scene, and turn them into interactable nodes.
 
 Here, we're setting a SpriteScene to put Trash Nodes and Apple Node.
```
 view = SKView(frame: UIScreen.main.bounds)
 let scene = GameScene(size: view.frame.size)
 view.presentScene(scene)
```
 
 SKNodes are declared like this
 ```
 let trashNode = SKShapeNode(circleOfRadius: 15)
 ```
 
 # Drag and Collision
 
 Dragging and Collision works in similar way as AR World.
 When we touch on our screen, the scene is notified of the coordinate of the touch, and the nodes can be moved around by updating its position.
 THere also is [SKPhysicsBody](glossary://SKPhysicsBody) in SpriteKit, which provides similar features as [SCNPhysicsBody](glossary://SCNPhysicsBody), such as detecting collision
 
 # Emitter
 
 Here, we'll look at something more interesting.
 
 [Emitter Nodes](glossary://SKEmitterNode) are nodes that create various particle effects. We can use them to create fire, smoke, explosion, and so much more.
 
 In this page, we'll use SKEmitterNode to explode trash nodes when they are hit by Apple node.
 
 Try to run this code and play with this SpriteKit View!
 */
//#-hidden-code
PlaygroundPage.current.assessmentStatus = .pass(message: "Did you know that Americans throw out phones with over $60 million in gold/silver every year? \n\n How can we save all those money? We'll explore how we can help save the world in the [Next Page](@next)!")
//#-end-hidden-code
