
//#-hidden-code
import UIKit
import PlaygroundSupport

var passed = false

func setUpAR() { // This is here to prevent errors in the playground
    let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy
    let command: PlaygroundValue
    proxy?.send(.string("setUpAR"))
//    PlaygroundPageBridge.send(value: .setUpAR, type: .update)
    passed = true
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Great! \n\n You just enabled AR!. Look around this world and explore it! \n\n[Next Page](@next)")
}

//#-end-hidden-code
/*:
 # Say Hello to AR
 
 ## What is AR?

 [Augmented Reality (AR)](glossary://AR) is an interactive experience that offers immersive, engaging experiences that blends virtual objects with the real world.
 
 Augmented Reality enables us to interact with the real-world from our phones, from playing 3d games to placing furnitures real-time.
 
 ## Now Let's try AR!
 
 To use AR, you have to enable camera usage, so be sure to click *OK*!
 
 You can call `setUpAR()` to enable AR and interact with the world.
 
 ````
 setUpAR()
 ````
 
 * callout(Goal:):
 Call the `setUpAR()` function to set up AR in the playground..
 */

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, setUpAR())
// Call the setUpAR function here
//#-editable-code

//#-end-editable-code

