//
//  Color.swift
//  Maedal
//
//  Created by Peter Choi on 2021/02/10.
//

import Foundation
import UIKit

class Color {
    static let colorNames = [
        "systemRed", "systemOrange", "systemYellow", "systemPink", "systemBlue", "systemIndigo",
        "systemGreen", "systemTeal", "systemPurple", "systemGray"
    ]
    
    static func getColor(name: String) -> UIColor {
        switch name {
        case "systemBlue":
            return UIColor.systemBlue
            
        case "systemRed":
            return UIColor.systemRed
            
        case "systemPink":
            return UIColor.systemPink
            
        case "systemTeal":
            return UIColor.systemTeal
            
        case "systemGrey", "systemGray":
            return UIColor.systemGray
            
        case "systemGreen":
            return UIColor.systemGreen
            
        case "systemOrange":
            return UIColor.systemOrange
            
        case "systemYellow":
            return UIColor.systemYellow
            
        case "systemPurple":
            return UIColor.systemPurple
            
        case "systemIndigo":
            return UIColor.systemIndigo
            
        default:
            return UIColor(named: name) ?? UIColor.systemBlue
        }
    }
}
