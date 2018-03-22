//
//  Category.swift
//  Todoey
//
//  Created by Jarek on 20/03/2018.
//  Copyright © 2018 Jarek. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colorHex: String = ""
    
    let items = List<ToDoItem>()
}
