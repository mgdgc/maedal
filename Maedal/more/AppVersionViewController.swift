//
//  AppVersionViewController.swift
//  Maedal
//
//  Created by Peter Choi on 2021/01/17.
//

import UIKit

class AppVersionViewController: UIViewController {
    
    @IBOutlet weak var appNameView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        appNameView.text = NSLocalizedString("app_name", comment: "app name")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onPrivacyButtonClick(_ sender: UIButton) {
        if let url = URL(string: AppValue.AboutApplication.privacyPolicyUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
