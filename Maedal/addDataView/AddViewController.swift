//
//  AddViewController.swift
//  Maedal
//
//  Created by Peter Choi on 2021/01/22.
//

import UIKit

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let SEG_ADD_SELECTION = "segAddSelection"
    private let SEG_ICON = "segIcon"
    
    private var data: [[AddTableViewData]] = Array()
    private var header: [String?] = Array()
    private var footer: [String?] = Array()
    
    var subscription: Subscription!
    private var editMode: Bool = false
    var onViewControllerDisappear: (() -> ())?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        initSubscriptionData()
        initTableViewData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        onViewControllerDisappear?()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == SEG_ICON {
            let vc = segue.destination as? IconViewController
            vc?.onSaveClickListener = { color, icon in
                self.subscription.icon = icon
                self.subscription.color = color
            }
        } else if segue.identifier == SEG_ADD_SELECTION {
            let section = self.tableView.indexPathForSelectedRow?.section ?? 0
            let row = self.tableView.indexPathForSelectedRow?.row ?? 0
            
            guard let vc = segue.destination as? SelectViewController else {
                return
            }
            
            switch self.data[section][row].id {
            case "category":
                vc.data = convertToSelectData(list: Category.getList())
                vc.onItemSelectedListener = { data in
                    self.subscription.category = data as? Category ?? .Entertainment
                }
                break
                
            case "payCycle":
                vc.data = convertToSelectData(list: PayCycle.getList())
                vc.onItemSelectedListener = { data in
                    self.subscription.payCycle = data as? PayCycle ?? .Monthly
                }
                break
                
            case "payMethod":
                vc.data = convertToSelectData(list: PayMethod.getList())
                vc.onItemSelectedListener = { data in
                    self.subscription.payMethod = data as? PayMethod ?? .AppStore
                }
                break
                
            default:
                break
            }
        }
    }
    
    private func convertToSelectData<T: IntBasedEnumProtocol>(list: [T]) -> [SelectItemData] {
        var data: [SelectItemData] = Array()
        list.forEach { i in
            data.append(SelectItemData(data: i, title: i.string(), detail: nil))
        }
        return data
    }
    
    // MARK: - Button Click Listeners
    
    @IBAction func onCancelButtonClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonClick(_ sender: UIBarButtonItem) {
        // TODO
        self.save()
    }
    
    // MARK: - TableView functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch data[indexPath.section][indexPath.row].type {
        case .editText:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditTextCell") as! EditTextCell
            
            cell.editText.placeholder = data[indexPath.section][indexPath.row].title
            
            if data[indexPath.section][indexPath.row].id == "price" {
                cell.editText.keyboardType = .numberPad
            }
            
            if let content = data[indexPath.section][indexPath.row].content {
                cell.editText.text = content
            }
            
            return cell
            
        case .toggle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell") as! ToggleCell
            
            cell.textView.text = data[indexPath.section][indexPath.row].title
            
            switch data[indexPath.section][indexPath.row].id {
            case "advanced":
                cell.onSwitchChangeListener = { value in
                    self.toggleAdvancedSetting(show: value)
                }
                break
                
            default: break
            }
            
            return cell
            
        case .selection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell") as! SelectionCell
            
            cell.textView.text = data[indexPath.section][indexPath.row].title
            if let content = data[indexPath.section][indexPath.row].content {
                cell.detailView.text = content
            } else {
                cell.detailView.text = ""
            }
            
            return cell
            
        case .button, .criticalButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
            
            cell.textView.text = data[indexPath.section][indexPath.row].title
            
            if data[indexPath.section][indexPath.row].type == .criticalButton {
                cell.textView.textColor = UIColor.red
            } else if data[indexPath.section][indexPath.row].type == .button {
                cell.textView.textColor = UIColor.link
            }
            
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
        switch self.data[indexPath.section][indexPath.row].id {
        case "icon":
            performSegue(withIdentifier: self.SEG_ICON, sender: nil)
            break
            
        case "category":
            performSegue(withIdentifier: SEG_ADD_SELECTION, sender: nil)
            break
            
        default:
            break
        }
    }
    
    // MARK: - Initialize Data
    
    private func initSubscriptionData() {
        if subscription == nil {
            subscription = Subscription(id: Subscription.generateId(), name: "", price: 0, date: "")
        } else {
            editMode = true
        }
    }
    
    private func initTableViewData() {
        // Main Section
        let main = [
            AddTableViewData(id: "name", title: NSLocalizedString("add_name", comment: ""), content: subscription.name, type: .editText),
            AddTableViewData(id: "advanced", title: NSLocalizedString("add_advanced", comment: ""), content: nil, type: .toggle)
        ]
        
        data.append(main)
        header.append(nil)
        footer.append(nil)
        
        // Subscription Info Section
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let subInfo = [
            AddTableViewData(id: "category", title: NSLocalizedString("add_category", comment: ""), content: nil, type: .selection),
            AddTableViewData(id: "date", title: NSLocalizedString("add_date", comment: ""), content: formatter.string(from: Date()), type: .selection)
        ]
        
        data.append(subInfo)
        header.append(NSLocalizedString("add_sub_info_header", comment: ""))
        footer.append(NSLocalizedString("add_footer_date", comment: ""))
        
        // Pay Section
        let pay = [
            AddTableViewData(id: "payCycle", title: NSLocalizedString("add_pay_cycle", comment: ""), content: nil, type: .selection),
            AddTableViewData(id: "payMethod", title: NSLocalizedString("add_pay_method", comment: ""), content: nil, type: .selection),
            AddTableViewData(id: "price", title: NSLocalizedString("add_pay_price", comment: ""))
        ]
        
        let currencyUnit = UserDefaults(suiteName: AppValue.appGroupId)?.string(forKey: UserDefaultsKeys.ApplicationSetting.stringCurrencyUnit) ?? "$"
        
        data.append(pay)
        header.append(NSLocalizedString("add_pay_header", comment: ""))
        footer.append(NSLocalizedString("\(NSLocalizedString("add_pay_footer", comment: ""))\(currencyUnit)", comment: ""))
        
        // Reminder Section
        let reminder = [
            AddTableViewData(id: "reminder", title: NSLocalizedString("add_reminder", comment: ""), content: nil, type: .selection)
        ]
        
        data.append(reminder)
        header.append(NSLocalizedString("add_reminder_header", comment: ""))
        footer.append(nil)
        
        // Icon Section
        let icon = [
            AddTableViewData(id: "icon", title: NSLocalizedString("add_icon", comment: ""), content: nil, type: .button)
        ]
        
        data.append(icon)
        header.append(NSLocalizedString("add_icon", comment: ""))
        footer.append(nil)
        
        // Delete and Clear Data
        if editMode {
            let delete = [
                AddTableViewData(id: "delete", title: NSLocalizedString("add_delete", comment: ""), content: nil, type: .criticalButton)
            ]
            
            data.append(delete)
            header.append(nil)
            footer.append(NSLocalizedString("add_delete_footer", comment: ""))
        } else {
            let clear = [
                AddTableViewData(id: "clear", title: NSLocalizedString("add_clear", comment: ""), content: nil, type: .button)
            ]
            
            data.append(clear)
            header.append(nil)
            footer.append(nil)
        }
        
    }
    
    // MARK: - TableViewCell hide/show
    
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
    
    private func toggleAdvancedSetting(show: Bool) {
        if show {
            let data = [
                AddTableViewData(id: "payMethodDetail", title: NSLocalizedString("add_pay_method_detail", comment: "")),
                AddTableViewData(id: "memo", title: NSLocalizedString("add_memo", comment: "")),
                AddTableViewData(id: "url", title: NSLocalizedString("add_url", comment: ""))
            ]
            
            showSetting(data: data, section: 0)
        } else {
            hideSetting(section: 0, count: 3)
        }
    }
    
    // MARK: - Regular Functions
    
    private func findDataById(id: String) -> IndexPath? {
        for i in 0..<self.data.count {
            for j in 0..<self.data[i].count {
                if self.data[i][j].id == id {
                    return IndexPath(row: j, section: i)
                }
            }
        }
        
        return nil
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
                case .editText:
                    dic.updateValue((cell as! EditTextCell).editText?.text ?? "", forKey: data.id)
                    continue
                    
                case .toggle:
                    dic.updateValue((cell as! ToggleCell).toggleView.isOn, forKey: data.id)
                    continue
                    
                case .selection:
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

// MARK: - Classes

class AddTableViewData {
    var id: String
    var title: String
    var content: String?
    var type: AddTableViewCellType = .editText
    
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
    case editText, toggle, selection, button, criticalButton
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
