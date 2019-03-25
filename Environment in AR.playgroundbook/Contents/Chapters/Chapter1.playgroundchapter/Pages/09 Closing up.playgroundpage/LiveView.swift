//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Instantiates a live view and passes it to the PlaygroundSupport framework.
//

import UIKit
import PlaygroundSupport
import ARKit



let viewController = FaceRecogViewController()
PlaygroundPage.current.liveView = viewController

PlaygroundPage.current.needsIndefiniteExecution = true

