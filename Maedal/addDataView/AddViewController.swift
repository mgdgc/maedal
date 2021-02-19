//
//  AddViewController.swift
//  Maedal
//
//  Created by Peter Choi on 2021/01/22.
//

import UIKit

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private static let SEG_ADD_SELECTION = "segAddSelection"
    private static let SEG_ICON = "segIcon"
    
    private var data: [[AddTableViewData]] = Array()
    private var header: [String?] = Array()
    private var footer: [String?] = Array()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        initTableViewData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onCancelButtonClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonClick(_ sender: UIBarButtonItem) {
        // TODO
        self.save()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch data[indexPath.section][indexPath.row].type {
        case .EditText:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTextCell") as! EditTextCell
            
            cell.editText.placeholder = data[indexPath.section][indexPath.row].title
            
            return cell
            
        case .Toggle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell") as! ToggleCell
            
            cell.textView.text = data[indexPath.section][indexPath.row].title
            
            switch data[indexPath.section][indexPath.row].id {
            case "advanced":
                cell.onSwitchChangeListener = { value in
                    self.toggleAdvancedSetting(show: value)
                }
                break
                
            case "reminder":
                cell.onSwitchChangeListener = { value in
                    self.toggleReminderSetting(show: value)
                }
                break
            default: break
            }
            
            return cell
            
        case .Selection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell") as! SelectionCell
            
            cell.textView.text = data[indexPath.section][indexPath.row].title
            if let content = data[indexPath.section][indexPath.row].content {
                cell.detailView.text = content
            } else {
                cell.detailView.text = ""
            }
            
            return cell
            
        case .Button:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
            
            cell.textView.text = data[indexPath.section][indexPath.row].title
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.header[section]
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.footer[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    private func initTableViewData() {
        // Main Section
        let main = [
            AddTableViewData(id: "name", title: NSLocalizedString("add_name", comment: "")),
            AddTableViewData(id: "advanced", title: NSLocalizedString("add_advanced", comment: ""), content: nil, type: .Toggle)
        ]
        
        data.append(main)
        header.append(nil)
        footer.append(nil)
        
        // Date Section
        let date = [
            AddTableViewData(id: "date", title: NSLocalizedString("add_date", comment: ""), content: nil, type: .Selection)
        ]
        
        data.append(date)
        header.append(nil)
        footer.append(NSLocalizedString("add_footer_date", comment: ""))
        
        // Pay Section
        let pay = [
            AddTableViewData(id: "payCycle", title: NSLocalizedString("add_pay_cycle", comment: ""), content: nil, type: .Selection),
            AddTableViewData(id: "payMethod", title: NSLocalizedString("add_pay_method", comment: ""), content: nil, type: .Selection),
            AddTableViewData(id: "price", title: NSLocalizedString("add_pay_price", comment: ""))
        ]
        
        data.append(pay)
        header.append(NSLocalizedString("add_pay_header", comment: ""))
        footer.append(nil)
        
        // Category Section
        let category = [AddTableViewData(id: "category", title: NSLocalizedString("add_category", comment: ""), content: nil, type: .Selection)]
        
        data.append(category)
        header.append(nil)
        footer.append(nil)
        
        // Reminder Section
        let reminder = [
            AddTableViewData(id: "reminder", title: NSLocalizedString("add_reminder", comment: ""), content: nil, type: .Toggle)
        ]
        
        data.append(reminder)
        header.append(NSLocalizedString("add_reminder_header", comment: ""))
        footer.append(nil)
        
    }
    
    private func showSetting(data: [AddTableViewData], section: Int) {
        let originalNumber = self.data[section].count
        
        for d in data {
            self.data[section].append(d)
        }
        
        var indexPath: [IndexPath] = Array()
        for i in originalNumber..<(originalNumber + data.count) {
            indexPath.append(IndexPath(row: i, section: section))
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: indexPath, with: .top)
        tableView.endUpdates()
    }
    
    private func hideSetting(section: Int, count: Int) {
        let originalNumber = self.data[section].count
        
        data[section].removeLast(count)
        
        var indexPath: [IndexPath] = Array()
        for i in 0..<count {
            indexPath.append(IndexPath(row: originalNumber - i - 1, section: section))
        }
        
        tableView.beginUpdates()
        tableView.deleteRows(at: indexPath, with: .top)
        tableView.endUpdates()
    }
    
    private func toggleReminderSetting(show: Bool) {
        if show {
            let data = [
                AddTableViewData(id: "reminder1", title: NSLocalizedString("add_reminder_1", comment: ""), content: nil, type: .Selection),
                AddTableViewData(id: "reminder2", title: NSLocalizedString("add_reminder_2", comment: ""), content: nil, type: .Selection),
                AddTableViewData(id: "reminder3", title: NSLocalizedString("add_reminder_3", comment: ""), content: nil, type: .Selection)
            ]
            
            showSetting(data: data, section: 4)
            
        } else {
            hideSetting(section: 4, count: 3)
        }
    }
    
    private func toggleAdvancedSetting(show: Bool) {
        if show {
            let data = [
                AddTableViewData(id: "memo", title: NSLocalizedString("add_memo", comment: "")),
                AddTableViewData(id: "url", title: NSLocalizedString("add_url", comment: ""))
            ]
            
            showSetting(data: data, section: 0)
        } else {
            hideSetting(section: 0, count: 2)
        }
    }
    
    private func save() {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        var dic: [String : Any] = Dictionary()
        
        for i in 0..<self.data.count {
            for j in 0..<self.data[i].count {
                let data = self.data[i][j]
                let indexPath = IndexPath(row: j, section: i)
                let cell = tableView.cellForRow(at: indexPath)
                
                switch data.type {
                case .EditText:
                    dic.updateValue((cell as! EditTextCell).editText?.text ?? "", forKey: data.id)
                    continue
                    
                case .Toggle:
                    dic.updateValue((cell as! ToggleCell).toggleView.isOn, forKey: data.id)
                    continue
                    
                case .Selection:
                    let value = (cell as! SelectionCell).value
                    if value is Int {
                        dic.updateValue(value ?? -1, forKey: data.id)
                    } else if value is String {
                        dic.updateValue(value ?? "", forKey: data.id)
                    } else if value is Bool {
                        dic.updateValue(value ?? false, forKey: data.id)
                    }
                    continue
                    
                default:
                    continue
                }
            }
        }
        
        let subscription = Subscription(json: dic)
        print(subscription)
        
    }

}

class AddTableViewData {
    var id: String
    var title: String
    var content: String?
    var type: AddTableViewCellType = .EditText
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    init(id: String, title: String, content: String?, type: AddTableViewCellType) {
        self.id = id
        self.title = title
        self.content = content
        self.type = type
    }
}

enum AddTableViewCellType {
    case EditText, Toggle, Selection, Button
}

class EditTextCell: UITableViewCell {
    @IBOutlet weak var editText: UITextField!
}

class ToggleCell: UITableViewCell {
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var toggleView: UISwitch!
    var onSwitchChangeListener: ((_ value: Bool) -> ())?
    
    @IBAction func onSwitchChange(_ sender: UISwitch) {
        onSwitchChangeListener?(sender.isOn)
    }
}

class SelectionCell: UITableViewCell {
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var detailView: UILabel!
    
    var value: Any?
}

class ButtonCell: UITableViewCell {
    @IBOutlet weak var textView: UILabel!
}
