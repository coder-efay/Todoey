//
//  Category.swift
//  Todoey
//
//  Created by Yifei Guo on 1/15/18.
//  Copyright © 2018 Yifei Guo. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
