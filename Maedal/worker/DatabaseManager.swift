//
//  DatabaseManager.swift
//  Maedal
//
//  Created by Peter Choi on 2021/01/30.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager {
    var subscriptions: [Subscription] = Array()
    
    func save(item: Subscription) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: DatabaseKey.Subscription.entity, in: context)
        
        if let entity = entity {
            let subscription = NSManagedObject(entity: entity, insertInto: context)
            
            subscription.setValue(item.id, forKey: DatabaseKey.Subscription.id)
            subscription.setValue(item.name, forKey: DatabaseKey.Subscription.name)
            subscription.setValue(item.payCycle, forKey: DatabaseKey.Subscription.payCycle)
            subscription.setValue(item.payMethod, forKey: DatabaseKey.Subscription.payMethod)
            subscription.setValue(item.category, forKey: DatabaseKey.Subscription.category)
            subscription.setValue(item.price, forKey: DatabaseKey.Subscription.price)
            subscription.setValue(item.memo, forKey: DatabaseKey.Subscription.memo)
            subscription.setValue(item.url, forKey: DatabaseKey.Subscription.url)
            subscription.setValue(item.reminder, forKey: DatabaseKey.Subscription.reminder)
            subscription.setValue(item.icon, forKey: DatabaseKey.Subscription.icon)
            subscription.setValue(item.color, forKey: DatabaseKey.Subscription.color)
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
                return false
            }
            
            return true
        } else {
            return false
        }
    }
    
    func get() -> [Subscription] {
        var result: [Subscription] = Array()
        
        let subs = getNSManagedObjects()
        
        subs.forEach { sub in
            var subscription = Subscription(
                id: Int(sub.id),
                name: sub.name ?? "",
                price: Double(Int(sub.price)),
                date: sub.date ?? "")
            
            subscription.memo = sub.memo
            subscription.url = sub.url
            subscription.payCycle = PayCycle(rawValue: Int(sub.payCycle)) ?? .Monthly
            subscription.payMethod = PayMethod(rawValue: Int(sub.payMethod)) ?? .AppStore
            subscription.payMethodDetail = sub.payMethodDetail
            subscription.category = Category(rawValue: Int(sub.category)) ?? .Entertainment
            subscription.color = sub.color ?? ""
            subscription.icon = sub.icon ?? ""
            
            subscription.reminder.removeAll()
            if let reminder = sub.reminder {
                for r in reminder {
                    if let item = Reminder(rawValue: r) {
                        subscription.reminder.append(item)
                    }
                }
            }
            
            result.append(subscription)
        }
        
        
        return result
    }
    
    func get(id: Int) -> Subs? {
        let list = getNSManagedObjects()
        
        for item in list {
            if item.id == id {
                return item
            }
        }
        
        return nil
    }
    
    func getNSManagedObjects() -> [Subs] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            return try context.fetch(Subs.fetchRequest()) as! [Subs]
        } catch {
            print(error.localizedDescription)
            return Array()
        }
    }
    
    func deleteAll() {
        
    }
    
    func delete(id: Int) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let sub = get(id: id) else {
            return false
        }
        
        context.delete(sub)
        
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }        
    }
    
}
