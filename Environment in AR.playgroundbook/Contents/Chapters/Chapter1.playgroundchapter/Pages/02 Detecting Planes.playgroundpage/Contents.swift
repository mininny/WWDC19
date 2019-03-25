
//#-hidden-code
import UIKit
import PlaygroundSupport
import ARKit
func enablePlaneDetection() { // This is here to prevent errors in the playground
    let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy
    let command: PlaygroundValue
    command = .dictionary([
        "Command": .string("planeColor"),
        "Message": PlaygroundValue.string(getHex(color: color))
        ])
    proxy?.send(command)
    proxy?.send(.string("enablePlaneDetection"))
//    PlaygroundPageBridge.send(value: "060606", type: .planeColor)
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Great! \n\n Now there are planes in the AR World!\n\nLocate planes by pointing your device to a flat surface! [Next Page](@next)")
}
//#-end-hidden-code
/*:
 # Planes
 
 Now, if we don't do anything with this AR technology, it is basically boring Camera App and would be useless, right?
 
 So let's try to put stuff into this virtual world!
 
 ## What is it?
 
 When you run a AR session, it can automatically detect [anchors](glossary://Anchor) and [flat surfaces](glossary://PlaneAnchor). We can access the position of the surfaces, and put a virtual plane on top of it!
 
 Let's try!
 
 ````
 enablePlaneDetection()
 ````

 * callout(Goal:):
 Call the `enablePlaneDetection()` function to enable plane detection in the playground, and adjust the color by changing the `color` variable.
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, enablePlaneDetection())
//#-hidden-code
var color: UIColor = #colorLiteral(red: 0, green: 0.1384256577, blue: 0.6781408091, alpha: 1)
//#-end-hidden-code
// call the enablePlaneDetection function here
//#-editable-code
color = #colorLiteral(red: 0, green: 0.1384256577, blue: 0.6781408091, alpha: 1)

//#-end-editable-code

