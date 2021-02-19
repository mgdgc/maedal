//
//  MoreViewController.swift
//  Maedal
//
//  Created by Peter Choi on 2021/01/13.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let segMonetaryUnit = "segMonetaryUnit"
    private let segAppInfo = "segAppInfo"

    @IBOutlet weak var tableView: UITableView!
    
    private var data: [[MoreVO]] = Array()
    private var header: [String?] = Array()
    private var footer: [String?] = Array()
    
    private var ud = AppValue.userDefaults
    
    var onViewControllerDisappear: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        initData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        onViewControllerDisappear?()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == segMonetaryUnit {
            let vc = segue.destination as? MonetaryUnitViewController
            vc?.onValueChangeListener = { (unit, onRight) in
                guard let section = self.tableView.indexPathForSelectedRow?.section else {
                    return
                }
                guard let row = self.tableView.indexPathForSelectedRow?.row else {
                    return
                }
                self.data[section][row].content = unit
                self.tableView.reloadData()
                
                self.ud.set(unit, forKey: UserDefaultsKeys.ApplicationSetting.stringCurrencyUnit)
                self.ud.set(onRight, forKey: UserDefaultsKeys.ApplicationSetting.boolCurrencyUnitOnRight)
            }
        }
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
            
        // Cell with Switch
        case .toggle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreSwitchCell") as! MoreSwitchCell
            
            cell.titleTextView.text = data.title
            
            if data.id == "decimal_point" {
                cell.toggleView.setOn(ud.bool(forKey: UserDefaultsKeys.ApplicationSetting.boolHideDecimalPoint), animated: false)
                
                cell.onSwitchChangeListener = { isOn in
                    self.ud.set(isOn, forKey: UserDefaultsKeys.ApplicationSetting.boolHideDecimalPoint)
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.data[indexPath.section][indexPath.row]
        
        switch data.id {
        case "currency_unit":
            self.performSegue(withIdentifier: segMonetaryUnit, sender: nil)
            break
            
        case "app_version":
            self.performSegue(withIdentifier: segAppInfo, sender: nil)
            break
            
        case "developer":
            break
            
        case "feedback":
            let alert = ActionSheetAlertManager(title: NSLocalizedString("more_feedback_title", comment: ""), message: NSLocalizedString("more_feedback_message", comment: ""))
            
            let supportPage = UIAlertAction(title: NSLocalizedString("more_feedback_web", comment: ""), style: .default) { action in
                if let url = URL(string: AppValue.AboutApplication.supportPageUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(supportPage)
            
            let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
            alert.addAction(cancel)
            
            self.present(alert.getActionSheetAlert(view: self.view), animated: true, completion: nil)
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
        // User Preference setting
        let preference = [
            MoreVO(id: "currency_unit", title: NSLocalizedString("more_monetary_unit", comment: ""), content: ud.string(forKey: UserDefaultsKeys.ApplicationSetting.stringCurrencyUnit), icon: nil, type: .detail),
            MoreVO(id: "decimal_point", title: NSLocalizedString("more_hide_decimal_point", comment: ""), content: nil, icon: nil, type: .toggle)
        ]
        
        data.append(preference)
        header.append(NSLocalizedString("more_app_setting_header", comment: ""))
        footer.append(NSLocalizedString("more_app_setting_footer", comment: ""))
        
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
    
    private func setDefaultValue() {
        // Currency Unit
        let currencyUnit = ud.string(forKey: UserDefaultsKeys.ApplicationSetting.stringCurrencyUnit) ?? "$"
        
        // Hide Decimal point
        let hideDecimalPoint = ud.bool(forKey: UserDefaultsKeys.ApplicationSetting.boolHideDecimalPoint)
        
        for i in 0..<data.count {
            for j in 0..<data[i].count {
                let cell = tableView.cellForRow(at: IndexPath(row: j, section: i))
                
                switch data[i][j].id {
                case "currency_unit":
                    (cell as! MoreCell).detailTextView.text = currencyUnit
                    continue
                    
                case "decimal_point":
                    (cell as! MoreSwitchCell).toggleView.isOn = hideDecimalPoint
                    continue
                    
                default:
                    continue
                }
            }
        }
        
    }
    
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

class MoreSwitchCell: UITableViewCell {
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var toggleView: UISwitch!
    
    var onSwitchChangeListener: ((_ isOn: Bool) -> ())?
    
    @IBAction func onSwitchChange(_ sender: UISwitch) {
        onSwitchChangeListener?(sender.isOn)
    }
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
    case icon, normal, detail, button, critialButton, toggle
}
