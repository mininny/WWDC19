//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Instantiates a live view and passes it to the PlaygroundSupport framework.
//

import UIKit
import PlaygroundSupport
import ARKit



let viewController = ARViewController()
viewController.setUpAR()
viewController.hitTestEnabled = true
PlaygroundPage.current.liveView = viewController

PlaygroundPage.current.needsIndefiniteExecution = true

