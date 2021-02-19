//
//  LicensesViewController.swift
//  Maedal
//
//  Created by Peter Choi on 2021/02/10.
//

import UIKit

class LicensesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var data: [License] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        initData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Tableview protocol stubs
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = data[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = ActionSheetAlertManager(title: NSLocalizedString("licenses_title", comment: ""), message: "\(data[indexPath.row].name)\n\nLicense: \(data[indexPath.row].license.rawValue)")
        
        let visit = UIAlertAction(title: NSLocalizedString("licenses_visit_url", comment: ""), style: .default) { (action) in
            // Open web site
            if let url = URL(string: self.data[indexPath.row].url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(visit)
        
        let close = UIAlertAction(title: NSLocalizedString("close", comment: ""), style: .cancel, handler: nil)
        alert.addAction(close)
            
        self.present(alert.getActionSheetAlert(view: self.view), animated: true, completion: nil)
        
    }
    
    // MARK: - Initialize Data
    
    private func initData() {
        data.removeAll()
        data.append(contentsOf: AppValue.Licenses.licenses)
        
        tableView.reloadData()
    }
    

}
