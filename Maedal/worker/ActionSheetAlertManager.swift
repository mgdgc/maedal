//
//  ActionSheetAlertManager.swift
//  Maedal
//
//  Created by Peter Choi on 2021/02/19.
//

import Foundation
import UIKit

class ActionSheetAlertManager {
    var title: String
    var message: String?
    var actions: [UIAlertAction] = Array()
    
    init(title: String, message: String?) {
        self.title = title
        self.message = message
    }
    
    func addAction(_ action: UIAlertAction) {
        actions.append(action)
    }
    
    func getActionSheetAlert(view: UIView) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for action in actions {
            alert.addAction(action)
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = view
                popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        
        return alert
    }
    
}
