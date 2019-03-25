
//#-hidden-code
import UIKit
import PlaygroundSupport
import ARKit
let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy
func createAppleNode(){
    
    proxy?.send(.string("createAppleNode"))
}
func enableDragging(){
    proxy?.send(.string("enableDragging"))
}
func createRandomTrash(){
    proxy?.send(.string("createRandomTrash"))
}
func enableCollision(){
    proxy?.send(.string("enableCollision"))
}

//#-end-hidden-code
/*:
 # Apple's Efforts and Collision
 
 The world is piling up with trash, and it looks pretty bad!
 
 Now let's find out how we can help :)
 
 There are many ways we can help as individuals, such as recycling, saving resources, and cleaning up our earth. However, efforts from large companies could help tremendously.
 
 Apple's Environment program promotes renewable products and using renewable energies. With a specialized disassembly robot, it can disassemble 200 iPhones per hour. Every product packagings are recycled or responsibly sourced, and by more efficiently packing gadgets in shipping container, Apple saves one 747 flight for every 370K phones.
 
 At https://www.apple.com/environment/ , you can find more about Apple's efforts in environment, and how companies can help improve the planet.
 
 # Physicsbody, Collision, and Drag
 
 In this page, we are learning about many new concepts.
 
 [Physics bodies](glossary://SCNPhysicsBody) simulates physic attributes, allowing us to detect collisions between objects and perform necessary calculations.
 
 Physicsbodies contain categoryBitMask, contactTestBitMask, and collisionBitMask, which defines the categories of bodies that cause intersection notifications between different physics bodies.
 
 
 Now continuing from our previous lesson of hit test, we will import an 3D Apple Logo node, and make it draggable. By getting continuous touch points and converting it with hit test, we can drag the node around our world!
 
 We will also add physics body to this node so we can enable collisions with trash nodes.
 
 * callout(Goal:):
 Create an Apple node with `createAppleNode()`. Then, enable dragging by calling `enableDragging()`
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, createAppleNode(), enableDragging())
//#-editable-code

//#-end-editable-code
/*:
 Great! If you run the code, you will see an Apple node that you can drag around.
 
 We will also add a physicsbody in each trash node, creating a physicsbody that has a **cateogry** of Trash Node and **contacting node** of Apple Node.
 
 Now, when Apple Node collides with Trash Nodes, Trash Nodes will explore out of the existance!
 
 * callout(Goal:):
 Generate trash nodes around you by calling `createRandomTrash()`
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, createRandomTrash())
//#-editable-code

//#-end-editable-code

//#-hidden-code
PlaygroundPage.current.assessmentStatus = .pass(message: "Dragging around the apple node will remove the trash! \n\n Every year, millions of dollars are saved by these genuine efforts:) Play around with the exploding trashes!\n\n[Next Page](@next)")
//#-end-hidden-code
