//
//  ToDoListControllerSearchBar.swift
//  Todoey
//
//  Created by Jarek on 20/03/2018.
//  Copyright © 2018 Jarek. All rights reserved.
//

import UIKit
import CoreData

extension ToDoListViewController: UISearchBarDelegate {
    func registerAsSearchBarDelegate() {
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        if searchText != "" {
//            let request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
//            request.predicate = NSPredicate(format: "title CONTAINS[cs] %@", searchText)
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            loadItems(with: request)
            loadItems(with: searchText)
        } else {
            loadItems()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text!.count == 0) {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
