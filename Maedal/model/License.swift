//
//  License.swift
//  Maedal
//
//  Created by Peter Choi on 2021/02/10.
//

import Foundation

struct License {
    var name: String
    var url: String
    var license: LicenseType
}

enum LicenseType: String {
    case apache2 = "Apache License Version 2.0"
    case mit = "MIT License"
    case gnu = "GNU General Public License"
    case free = "Free"
    case noInfo = "No information"
}
