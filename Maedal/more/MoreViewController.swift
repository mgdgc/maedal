//
//  MoreViewController.swift
//  Maedal
//
//  Created by Peter Choi on 2021/01/13.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var data: [[MoreVO]] = Array()
    private var header: [String?] = Array()
    private var footer: [String?] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        initData()
    }

    // MARK: - Tableview Protocol Subs
    
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
        // Cell with detail content and disclosure
        case .normal, .detail:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell") as! MoreCell
            
            if data.type == .normal {
                cell.accessoryType = .none
            }
            
            cell.titleTextView.text = data.title
            cell.detailTextView.text = data.content
            
            return cell
            
        // Cell with icon
        case .icon:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreIconCell") as! MoreIconCell
            
            cell.iconView.image = data.icon
            cell.titleTextView.text = data.title
            if let detail = data.content {
                cell.detailTextView.text = detail
            }
            
            return cell
            
        // Cell with Button
        case .button, .critialButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreButtonCell") as! MoreButtonCell
            
            if data.type == .button {
                cell.buttonTextView.textColor = UIColor.link
            } else if data.type == .critialButton {
                cell.buttonTextView.textColor = UIColor.red
            }
            
            cell.buttonTextView.text = data.title
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.data[indexPath.section][indexPath.row]
        
        switch data.id {
        case "app_version":
            self.performSegue(withIdentifier: "segAppInfo", sender: nil)
            break
            
        case "developer":
            break
            
        case "feedback":
            break
            
        default:
            break
        }
    }
    
    // MARK: - Button Click Listener
    
    @IBAction func onDoneButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Initialize Data
    
    func initData() {
        // Local setting
        let local = [
            MoreVO(id: "monetary_unit", title: NSLocalizedString("more_monetary_unit", comment: ""), content: nil, icon: nil, type: .detail)
        ]
        
        data.append(local)
        header.append(NSLocalizedString("more_app_setting", comment: ""))
        footer.append(nil)
        
        // Application information
        let appInfo = [
            MoreVO(id: "app_version", title: NSLocalizedString("app_name", comment: ""), content: "v1.0", icon: UIImage(named: "app_icon_symbol_64px") ?? UIImage(), type: MoreCellType.icon),
            MoreVO(id: "developer", title: NSLocalizedString("more_developer", comment: ""), content: NSLocalizedString("more_developer_name", comment: ""), icon: nil, type: .normal),
            MoreVO(id: "feedback", title: NSLocalizedString("more_feedback", comment: ""), content: nil, icon: nil, type: .detail)
        ]
        
        data.append(appInfo)
        header.append(NSLocalizedString("more_app_header", comment: ""))
        footer.append(nil)
        
        // Application data
        let appData = [
            MoreVO(id: "delete_subs", title: NSLocalizedString("more_delete_subs", comment: ""), content: nil, icon: nil, type: .button),
            MoreVO(id: "delete_all", title: NSLocalizedString("more_delete_all", comment: ""), content: nil, icon: nil, type: .critialButton)
        ]
        
        data.append(appData)
        header.append(NSLocalizedString("more_delete_header", comment: ""))
        footer.append(NSLocalizedString("more_delete_footer", comment: ""))
        
        tableView.reloadData()
    }
    
    // MARK: - Functions
    
}

// MARK: - Classes

class MoreCell: UITableViewCell {
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var detailTextView: UILabel!
}

class MoreIconCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var detailTextView: UILabel!
}

class MoreButtonCell: UITableViewCell {
    @IBOutlet weak var buttonTextView: UILabel!
}

class MoreVO {
    var title: String
    var content: String?
    var id: String
    var type: MoreCellType = .normal
    var icon: UIImage?
    var selectable: Bool = true
    
    init(id: String, title: String, content: String?, icon: UIImage?, type: MoreCellType) {
        self.id = id
        self.title = title
        self.content = content
        self.icon = icon
        self.type = type
    }
    
}

enum MoreCellType {
    case icon, normal, detail, button, critialButton
}
