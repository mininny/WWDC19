//
//  PlaygroundConstants.swift
//  Book_Sources
//
//  Created by Minhyuk Kim on 17/03/2019.
//

import Foundation
import PlaygroundSupport
import UIKit
import ARKit

extension UIColor {
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    var hexString: String {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        
        return String(format: "#%06x", rgb)
    }
}

public func getHex(color: UIColor) -> String{
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    
    let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
    
    return String(format: "%06x", rgb)
}

struct CollisionCategory: OptionSet {
    let rawValue: Int
    
    static let trashCategory  = CollisionCategory(rawValue: 1 << 0)
    static let appleCategory = CollisionCategory(rawValue: 1 << 1)
    static let allCategory = CollisionCategory(rawValue: 1 << 2)
}

extension SCNVector3{
    static func + (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(l.x + r.x, l.y + r.y, l.z + r.z)
    }
}
