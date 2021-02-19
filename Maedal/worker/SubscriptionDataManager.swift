//
//  DataManager.swift
//  Maedal
//
//  Created by Peter Choi on 2021/02/19.
//

import Foundation

class SubscriptionDataManager {
    private let ud = AppValue.userDefaults
    
    func getIdList() -> [Int] {
        if let list = ud.array(forKey: UserDefaultsKeys.Subscription.intArrlist) as? [Int] {
            return list
        }
        return Array()
    }
    
    func updateIdList(ids: [Int]) {
        ud.set(ids, forKey: UserDefaultsKeys.Subscription.intArrlist)
    }
    
    func updateIdList(data: [Subscription]) {
        var ids: [Int] = Array()
        for d in data {
            ids.append(d.id)
        }
        updateIdList(ids: ids)
    }
    
    func getData(id: Int) -> Subscription? {
        let achievedData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeys.Subscription.stringId)\(id)")
        do {
            let sub = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(achievedData as! Data) as! Subscription
            
            return sub
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    func getData(ids: [Int]) -> [Subscription] {
        var data: [Subscription] = Array()
        for i in ids {
            if let d = getData(id: i) {
                data.append(d)
            }
        }
        
        return data
    }
    
    func getData() -> [Subscription] {
        return getData(ids: getIdList())
    }
    
    func save(subscription: Subscription) -> Bool {
        do {
            // Save Subscription data
            let key = "\(UserDefaultsKeys.Subscription.stringId)\(subscription.id)"
            let sub = try NSKeyedArchiver.archivedData(withRootObject: subscription, requiringSecureCoding: false)
            UserDefaults.standard.set(sub, forKey: key)
            
            // Update Id list
            var ids = getIdList()
            ids.append(subscription.id)
            updateIdList(ids: ids)
            
            return true
            
        } catch let error {
            print(error)
            return false
        }
    }
    
    func removeAll() {
        let list = getIdList()
        
        for i in 0..<list.count {
            ud.removeObject(forKey: "\(UserDefaultsKeys.Subscription.stringId)\(list[i])")
        }
    }
    
    func remove(id: Int) {
        var ids = getIdList()
        
        ud.removeObject(forKey: "\(UserDefaultsKeys.Subscription.stringId)\(id)")
        
        for i in 0..<ids.count {
            if ids[i] == id {
                ids.remove(at: i)
            }
        }
        
        
    }
}
