//
//  Subscription.swift
//  Maedal
//
//  Created by Peter Choi on 2021/01/14.
//

import Foundation

class Subscription: NSObject, NSCoding {
    var id: Int
    var name: String
    var payCycle: PayCycle = PayCycle.Monthly
    var payMethod: PayMethod = PayMethod.AppStore
    var payMethodDetail: String?
    var category: Category = Category.Entertainment
    var price: Double
    var memo: String?
    var url: String?
    var date: String
    var reminder: [Reminder] = Array()
    var icon: String?
    var color: String?
    
    required init?(coder: NSCoder) {
        self.id = coder.decodeInteger(forKey: "id")
        self.name = coder.decodeObject(forKey: "name") as! String
        self.payCycle = PayCycle(rawValue: coder.decodeInteger(forKey: "payCycle")) ?? .Monthly
        self.payMethod = PayMethod(rawValue: coder.decodeInteger(forKey: "payMethod")) ?? .AppStore
        self.payMethodDetail = coder.decodeObject(forKey: "payMethodDetail") as? String
        self.category = Category(rawValue: coder.decodeInteger(forKey: "category")) ?? .Etc
        self.price = coder.decodeDouble(forKey: "price")
        self.memo = coder.decodeObject(forKey: "memo") as? String
        self.url = coder.decodeObject(forKey: "url") as? String
        self.date = coder.decodeObject(forKey: "date") as! String
        var reminder: [Reminder] = Array()
        let reminderInt = coder.decodeObject(forKey: "reminder") as! [Int]
        reminderInt.forEach { i in
            if let r = Reminder(rawValue: i) {
                reminder.append(r)
            }
        }
        self.reminder.removeAll()
        self.reminder.append(contentsOf: reminder)
        self.icon = coder.decodeObject(forKey: "icon") as? String
        self.color = coder.decodeObject(forKey: "color") as? String
        
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: "id")
        coder.encode(self.name, forKey: "name")
        coder.encode(self.payCycle, forKey: "payCycle")
        coder.encode(self.payMethod, forKey: "payMethod")
        coder.encode(self.payMethodDetail, forKey: "payMethodDetail")
        coder.encode(self.category, forKey: "category")
        coder.encode(self.price, forKey: "memo")
        coder.encode(self.url, forKey: "url")
        coder.encode(self.date, forKey: "date")
        coder.encode(self.reminder, forKey: "reminder")
        var reminder: [Int] = Array()
        for r in self.reminder {
            reminder.append(r.rawValue)
        }
        coder.encode(reminder, forKey: "reminder")
        coder.encode(self.icon, forKey: "icon")
        coder.encode(self.color, forKey: "color")
        
    }
    
    init (id: Int, name: String, price: Double, date: String) {
        self.id = id
        self.name = name
        self.price = price
        self.date = date
    }
    
    init (json: [String: Any]) {
        self.id = json["id"] as? Int ?? -1
        self.name = json["name"] as? String ?? ""
        self.price = json["price"] as? Double ?? -1
        self.date = json["date"] as? String ?? ""
        self.payCycle = PayCycle(rawValue: Int(json["payCycle"] as? String ?? "\(PayCycle.Monthly.rawValue)") ?? PayCycle.Monthly.rawValue) ?? .Monthly
        self.payMethod = PayMethod(rawValue: Int(json["payMethod"] as? String ?? "\(PayMethod.AppStore.rawValue)") ?? PayMethod.AppStore.rawValue) ?? .AppStore
        self.category = Category(rawValue: Int(json["category"] as? String ?? "\(Category.Entertainment.rawValue)") ?? Category.Entertainment.rawValue) ?? .Etc
        self.memo = json["memo"] as? String
        self.url = json["url"] as? String
        self.payMethodDetail = json["payMethodDetail"] as? String ?? ""
        
        if let reminderJson = json["reminder"] as? String {
            let components = reminderJson.components(separatedBy: ",")
            for i in components {
                if let rawValue = Int(i.trimmingCharacters(in: [" "])) {
                    if let value = Reminder(rawValue: rawValue) {
                        if let reminder = Reminder(rawValue: value.rawValue) {
                            self.reminder.append(reminder)
                        }
                    }
                }
            }
        }
    }
    
    static func generateId() -> Int {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = AppValue.DateValue.idDateFormat
        
        return Int(format.string(from: date))!
    }
    
    static func getDateFromString(from: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = AppValue.DateValue.dateFormat
        dateFormat.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        return dateFormat.date(from: from) ?? Date()
    }
    
    static func getPriceString(price: Double) -> String {
        let ud = AppValue.userDefaults
        
        let unit = ud.string(forKey: UserDefaultsKeys.ApplicationSetting.stringCurrencyUnit) ?? "$"
        var priceString = String(price)
        if ud.bool(forKey: UserDefaultsKeys.ApplicationSetting.boolHideDecimalPoint) {
            if round(price) == price {
                priceString = String(Int(round(price)))
            }
        }
        
        if ud.bool(forKey: UserDefaultsKeys.ApplicationSetting.boolCurrencyUnitOnRight) {
            return "\(priceString)\(unit)"
        } else {
            return "\(unit)\(priceString)"
        }
        
    }
    
}

protocol IntBasedEnumProtocol {
    func string() -> String
}

enum PayCycle: Int, IntBasedEnumProtocol {
    case Monthly = 0, Weekly = 1, Daily = 2
    
    static func getList() -> [PayCycle] {
        return [.Monthly, .Weekly, .Daily]
    }
    
    func string() -> String {
        switch self {
        case .Monthly: return NSLocalizedString("cycle_monthly", comment: "")
        case .Weekly: return NSLocalizedString("cycle_weekly", comment: "")
        case .Daily: return NSLocalizedString("cycle_daily", comment: "")
        }
    }
}

enum PayMethod: Int, IntBasedEnumProtocol {
    case AppStore = 0, Card = 1, Transfer = 2, BankAccount = 3, Cash = 4
    
    static func getList() -> [PayMethod] {
        return [.AppStore, .Card, .Transfer, .BankAccount, .Cash]
    }
    
    func string() -> String {
        switch self {
        case .AppStore: return NSLocalizedString("method_appstore", comment: "")
        case .Card: return NSLocalizedString("method_card", comment: "")
        case .Transfer: return NSLocalizedString("method_transfer", comment: "")
        case .BankAccount: return NSLocalizedString("method_bank", comment: "")
        case .Cash: return NSLocalizedString("method_cash", comment: "")
        }
    }
}

enum Category: Int, IntBasedEnumProtocol {
    case Video = 1, Utility = 2, Education = 3, Food = 4, LifeStyle = 5, News = 6, Music = 7, Entertainment = 8, Etc = 0
    
    static func getList() -> [Category] {
        return [.Video, .Entertainment, .Music, .LifeStyle, .Utility, .Education, .Food, .News]
    }
    
    func string() -> String {
        switch self {
        case .Education: return NSLocalizedString("category_education", comment: "")
        case .Entertainment: return NSLocalizedString("category_entertainment", comment: "")
        case .Food: return NSLocalizedString("category_food", comment: "")
        case .LifeStyle: return NSLocalizedString("category_lifestyle", comment: "")
        case .Music: return NSLocalizedString("category_music", comment: "")
        case .News: return NSLocalizedString("category_news", comment: "")
        case .Utility: return NSLocalizedString("category_utility", comment: "")
        case .Video: return NSLocalizedString("category_video", comment: "")
        case .Etc: return NSLocalizedString("category_etc", comment: "")
        }
    }
}

enum Reminder: Int {
    case DDAY = 0, OneDayBefore = 1, TwoDayBefore = 2, WeekBefore = 7
}
