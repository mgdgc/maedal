//
//  SubscriptionDetailViewController.swift
//  Maedal
//
//  Created by Peter Choi on 2021/02/12.
//

import UIKit

class SubscriptionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var data: [[SubscriptionDetailData]] = Array()
    private var header: [String?] = Array()
    private var footer: [String?] = Array()
    
    private let ud = AppValue.userDefaults
    
    var subscription: Subscription!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Tableview Protocol stubs
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footer[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = self.data[indexPath.section][indexPath.row]
        
        switch data.type {
        case .basic:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailBasicCell") as! DetailBasicCell
            
            cell.titleTextView.text = data.title
            cell.contentTextView.text = data.content
            
            return cell
            
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailNameCell") as! DetailNameCell
            
            cell.titleTextView.text = data.title
            cell.iconView.image = UIImage(named: subscription.icon ?? "")
            cell.iconBackgroundView.backgroundColor = Color.getColor(name: subscription.color ?? Color.colorNames[0])
            
            return cell
            
        case .toggle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailToggleCell") as! DetailToggleCell
            
            cell.titleTextView.text = data.title
            
            if data.id == "additional_toggle" {
                cell.onToggleChangeListener = { sender in
                    
                }
            }
            
            return cell
            
        }
    }
    
    // MARK: - Initializing Data
    
    private func initData() {
        // Name
        let name = [
            SubscriptionDetailData(id: "name", title: subscription.name, type: .name)
        ]
        
        data.append(name)
        header.append(nil)
        footer.append(nil)
        
        // Additional Info
        let additional = [
            SubscriptionDetailData(id: "additional_toggle", title: NSLocalizedString("detail_additional", comment: ""), type: .toggle)
        ]
        
        data.append(additional)
        header.append(NSLocalizedString("detail_additional", comment: ""))
        footer.append(nil)
        
        // Subscription Info
        let subInfo = [
            SubscriptionDetailData(id: "category", title: NSLocalizedString("add_category", comment: ""), content: subscription.category.string()),
            SubscriptionDetailData(id: "date", title: NSLocalizedString("add_date", comment: ""), content: subscription.date)
        ]
        
        data.append(subInfo)
        header.append(NSLocalizedString("add_sub_info_header", comment: ""))
        footer.append(nil)
        
        // Payments
        var payments = [
            SubscriptionDetailData(id: "payCycle", title: NSLocalizedString("add_pay_cycle", comment: ""), content: subscription.payCycle.string()),
            SubscriptionDetailData(id: "payMethod", title: NSLocalizedString("add_pay_method", comment: ""), content: subscription.payMethod.string()),
            SubscriptionDetailData(id: "price", title: NSLocalizedString("add_pay_price", comment: ""), content: nil)
        ]
        
        payments[2].content = Subscription.getPriceString(price: subscription.price)
        
        data.append(payments)
        header.append(NSLocalizedString("add_pay_header", comment: ""))
        footer.append(nil)
        
        // Reminder
//        let reminder =
    }
    

}

// MARK: - Classes

struct SubscriptionDetailData {
    var id: String
    var title: String
    var content: String?
    var type: SubscriptionDetailCellType = .basic
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    init(id: String, title: String, content: String?) {
        self.init(id: id, title: title, content: content, type: .basic)
    }
    
    init(id: String, title: String, type: SubscriptionDetailCellType) {
        self.init(id: id, title: title, content: nil, type: type)
    }
    
    init(id: String, title: String, content: String?, type: SubscriptionDetailCellType) {
        self.init(id: id, title: title)
        self.content = content
        self.type = type
    }
}

enum SubscriptionDetailCellType {
    case basic, name, toggle
}

class DetailNameCell: UITableViewCell {
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var iconView: UIImageView!
}

class DetailBasicCell: UITableViewCell {
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var contentTextView: UILabel!
}

class DetailToggleCell: UITableViewCell {
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var toggleView: UISwitch!
    
    var onToggleChangeListener: ((_ sender: UISwitch) -> ())?
    
    @IBAction func onSwitchChange(_ sender: UISwitch) {
        onToggleChangeListener?(sender)
    }
}
