
//#-hidden-code
import UIKit
import PlaygroundSupport
import SpriteKit


//#-end-hidden-code
/*:
 Now that we know the basics about AR and its capabilities, let's get to the main topic.
 
 # The environment
 
 As a part of humanity, I care deeply about our mother earth.
 
 We really love our iPhones, iPads, and MacBooks, and they do a lot to help us. However, as much as we love these devices, we should think about its costs.
 
 # E-Waste
 
 E-wastes are Electronic Waste that is fastest growing segments of our waste stream.
 
 Every year, over **50 million tons** of electronic waste is created, and in U.S. alone, over **140 million cell phones** are thrown into landfills every year.
 
 Yet, a large number of e-wastes can actually be reused or recycled for other purposes.
 
 In this page, we will import a scn file(a 3D model) and use it to visualize the amount of trash in our environment.
 
 * callout(Goal:):
 Select the trash node type, and try to put e-wastes around you and see how much it is!
 
 
 Put trash nodes around you until the progress bar at the top is full!
 
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, trash, .)
let nodeType : NodeType = .trash

//#-hidden-code
let page = PlaygroundPage.current
page.needsIndefiniteExecution = true

let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy
var command: PlaygroundValue
public class Listener: PlaygroundRemoteLiveViewProxyDelegate {
    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy,
                             received message: PlaygroundValue) {
        proxy?.send(.string("enablePlaneDetection"))
        PlaygroundPage.current.assessmentStatus = .pass(message: "# That's a lot of trash! \n\n Each node of trash represents 1 millions tons of waste produced each year. This is definitely bad for our earth! How can we help?\n\n[Next Page](@next)")
        ////        switch message{
        ////
        ////        case let .string(text):
        ////            proxy?.send(.string("enablePlaneDetection"))
        ////            switch text{
        ////            case "asdf":
        ////                page.assessmentStatus = .pass(message: "# Good Job! \n\n How was it playing with different types of nodes? Play around with it, then proceed to next page!\n\n[Next Page](@next)")
        ////                break
        ////            default:
        ////                break
        ////            }
        ////        default:
        ////            proxy?.send(.string("enablePlaneDetection"))
        ////            break
        ////        }
        ////        guard let liveViewMessage = PlaygroundMessageFromLiveView(playgroundValue: message) else {
        ////            page.assessmentStatus = .pass(message: "# Good Job! \n\n How was it playing with different types of nodes? Play around with it, then proceed to next page!\n\n[Next Page](@next)")
        ////            return
        ////        }
        ////
        ////        switch liveViewMessage {
        ////        case .succeeded:
        ////            page.assessmentStatus = .pass(message: "# Good Job! \n\n How was it playing with different types of nodes? Play around with it, then proceed to next page!\n\n[Next Page](@next)")
        ////
        ////        default:
        ////            break
    }
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
        PlaygroundPage.current.finishExecution()
    }
}
proxy!.delegate = Listener()

proxy?.receive(.string("asdf"))
command = .dictionary([
    "Command": .string("nodeType"),
    "Message": PlaygroundValue.string(nodeType.rawValue)
    ])
proxy?.send(command)
proxy?.send(.string("enableTrashNode"))

PlaygroundPage.current.assessmentStatus = .pass(message: "# That's a lot of trash! \n\n Each node of trash represents 1 millions tons of waste produced each year. This is definitely bad for our earth! How can we help?\n\n[Next Page](@next)")

//#-end-hidden-code
