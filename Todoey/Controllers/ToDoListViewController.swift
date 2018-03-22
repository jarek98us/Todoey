//
//  ViewController.swift
//  Todoey
//
//  Created by Jarek on 19/03/2018.
//  Copyright © 2018 Jarek. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let realm = try! Realm()
    var items: Results<ToDoItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerAsSearchBarDelegate()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = items?[indexPath.row]
        if item != nil {
            cell.textLabel?.text = item!.title
            cell.accessoryType = item!.done ? .checkmark : .none
        }
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row), item: \(String(describing: items?[indexPath.row]))")
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error: \(error)")
            }
            //tableView.reloadData()
            tableView.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func loadItems(with substring: String = "") {
        items = selectedCategory!.items.sorted(byKeyPath: "createdAt", ascending: true)
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (newTextField) in
            newTextField.placeholder = "Create new item"
            textField = newTextField
        }

        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            
            if (textField.text != nil), let category = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = ToDoItem()
                        newItem.title = textField.text!
                        category.items.append(newItem)
                    }
                }  catch {
                        print("Error: \(error)")
                }
                
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

