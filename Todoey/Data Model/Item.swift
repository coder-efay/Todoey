//
//  Item.swift
//  Todoey
//
//  Created by Yifei Guo on 1/15/18.
//  Copyright © 2018 Yifei Guo. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")     // identify the relationship what is the parent category
    
    
}
