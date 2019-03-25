//#-hidden-code
import UIKit
import PlaygroundSupport

func enableHitTest() {
    let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy
    let command: PlaygroundValue
    proxy?.send(.string("enableHitTest"))
    //    PlaygroundPageBridge.send(value: .setUpAR, type: .update)
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Congratulations! \n\n You just learned about Hit Test!\n\n Press almost anywhere in your screen to put a node! \n\n[Next Page](@next)")
}
//#-end-hidden-code
/*:
 # Hit Test

 Adding planes to the real world was fun and all, but can we do more?
 
 Yes, definitely!
 
 We can add [SCNNodes](glossary://SCNNode) to our AR World, but before we do that, we have to find a way to add the nodes to the world. One great way to add them is [**Hit Test**](glossary://HitTest).
 
 
 # What is Hit Test?
 
 When you move around your camera right now, you will see yellow dots on various objects and points called [**Feature Points**](glossary://FeaturePoint).
 When a user touches a location in the screen, the ARKit tries to convert that location into most appropriate 3d location that is detected by Feature Points.
 
 Hit testing searches for real-world objects or surfaces detected through the AR session's processing of the camera image. A 2D Point is converted to 3D point with x,y,z, and returned as `ARHitTestResult`.
 
 # Let's try to actually put objects in the AR World!
 
 ````
 enableHitTest()
 ````
 * callout(Goal:):
 Call the `enableHitTest()` function to enable Hit Test and add nodes into our AR World.
 
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, enableHitTest())
// call the enableHitTest function here
//#-editable-code

//#-end-editable-code
