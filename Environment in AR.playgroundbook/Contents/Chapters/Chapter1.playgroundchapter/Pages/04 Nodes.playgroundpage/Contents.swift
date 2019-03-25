
//#-hidden-code
import UIKit
import PlaygroundSupport
import SpriteKit


//#-end-hidden-code
/*:
 # Nodes
 
 We've tried using Hit Test to add spheres to our AR world, but can we do more?
 
 Definitely! There are variety of different SCNNodes that we can use, such as [cylinder](glossary://SCNCylinder), [box](glossary://SCNBox), and [cone](glossary://SCNCone).
 
 
 # Types of SCNNodes
 
 In this page, you will play around with different variables!
 
 Try playing with different colors, sizes, and shapes of nodes!
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, ., sphere, cone, cylinder, tube, capsule, box)
 let nodeType : NodeType = /*#-editable-code*/.box/*#-end-editable-code*/
let nodeColor : UIColor = /*#-editable-code*/#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)/*#-end-editable-code*/
let nodeSize = /*#-editable-code*/0.03/*#-end-editable-code*/

//#-hidden-code
let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy
var command: PlaygroundValue
command = .dictionary([
    "Command": .string("nodeColor"),
    "Message": PlaygroundValue.string(getHex(color: nodeColor))
    ])
proxy?.send(command)
command = .dictionary([
    "Command": .string("nodeSize"),
    "Message": PlaygroundValue.floatingPoint(nodeSize)
    ])
proxy?.send(command)
command = .dictionary([
    "Command": .string("nodeType"),
    "Message": PlaygroundValue.string(nodeType.rawValue)
    ])
proxy?.send(command)
PlaygroundPage.current.assessmentStatus = .pass(message: "# Good Job! \n\n How was it playing with different types of nodes? Play around with it, then proceed to [Next Page](@next)!")
//#-end-hidden-code
