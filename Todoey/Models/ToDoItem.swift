//
//  ToDoItem.swift
//  Todoey
//
//  Created by Jarek on 19/03/2018.
//  Copyright © 2018 Jarek. All rights reserved.
//

import Foundation

class ToDoItem: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
    
    init (_ title: String) {
        self.title = title
    }
}
