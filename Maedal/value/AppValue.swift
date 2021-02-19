//
//  AppValue.swift
//  Maedal
//
//  Created by Peter Choi on 2021/01/29.
//

import Foundation

class AppValue {
    static let appGroupId = "group.Maedal"
//    static let userDefaults = UserDefaults(suiteName: appGroupId)
    static let userDefaults = UserDefaults.standard
    
    class DateValue {
        static let idDateFormat = "yyyyMMddHHmmss"
        static let dateFormat = "yyyyMMdd"
    }
    
    class Licenses {
        static let materialColor = License(name: "Material Design Color", url: "https://material.io/tools/color/#!/?view.left=0&view.right=0", license: .noInfo)
        static let materialIcon = License(name: "Material Design Icon", url: "https://material.io/resources/icons/?style=baseline", license: .apache2)
        
        static let licenses = [
            materialIcon, materialColor
        ]
    }
    class AboutApplication {
        static let privacyPolicyUrl = "https://ridsoft.xyz/basic_policy.html"
        static let supportPageUrl = "https://ridsoft.xyz/service.html"
    }
    
}
