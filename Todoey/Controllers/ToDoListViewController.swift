//
//  ViewController.swift
//  Todoey
//
//  Created by Jarek on 19/03/2018.
//  Copyright © 2018 Jarek. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
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
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        
        if let backgroundColor = UIColor(hexString: selectedCategory!.colorHex) {
            let foregroundColor = ContrastColorOf(backgroundColor, returnFlat: true)
            navBar.barTintColor = backgroundColor
            title = selectedCategory!.name
            searchBar.barTintColor = backgroundColor
        
            navBar.tintColor = foregroundColor
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: foregroundColor]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let navBar = navigationController?.navigationBar {
            navBar.barTintColor = UIColor(hexString: "007AFF")
            navBar.tintColor = FlatWhite()
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: FlatWhite()]
        }
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
        
        let cell = super.getCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = items?[indexPath.row]
        if item != nil {
            cell.textLabel?.text = item!.title
            cell.accessoryType = item!.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory!.colorHex) {
                cell.backgroundColor = color
                    .darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count))
                
                let foregroundColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
                cell.textLabel!.textColor = foregroundColor
                cell.tintColor = foregroundColor
            }
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
    
    override func deleteRow(rowIndex: Int) {
        if let item = self.items?[rowIndex] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error when deleting item: \(error)")
            }
            
        }
    }
}

