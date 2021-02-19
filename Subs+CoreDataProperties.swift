//
//  Subs+CoreDataProperties.swift
//  Maedal
//
//  Created by Peter Choi on 2021/02/02.
//
//

import Foundation
import CoreData


extension Subs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subs> {
        return NSFetchRequest<Subs>(entityName: "Subs")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var price: Int64
    @NSManaged public var category: Int16
    @NSManaged public var payCycle: Int16
    @NSManaged public var payMethod: Int16
    @NSManaged public var reminder: [Int]?
    @NSManaged public var date: String?
    @NSManaged public var icon: String?
    @NSManaged public var color: String?
    @NSManaged public var memo: String?
    @NSManaged public var url: String?

}

extension Subs : Identifiable {

}
