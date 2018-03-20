//
//  ViewController.swift
//  Todoey
//
//  Created by Jarek on 19/03/2018.
//  Copyright © 2018 Jarek. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    var itemArray = [ToDoItem]()
    
    // let defaults = UserDefaults.standard
    // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let persistentContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row), item: \(itemArray[indexPath.row])")
        
        let item = itemArray[indexPath.row]
        item.done = !item.done
        tableView.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK - Add new Items
    fileprivate func saveItems(refreshItems: Bool = false) {
        if persistentContext.hasChanges {
            do {
                try persistentContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
        
        if (refreshItems) {
            self.tableView.reloadData()
        }
    }
    
    func loadItems(with substring: String = "") {
        let request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        let categoryPredicate = NSPredicate(format: "itemCategory.name MATCHES %@", selectedCategory!.name!)
        
        if (substring.count > 0) {
            let substringPredicate = NSPredicate(format: "title CONTAINS[cs] %@", substring)
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, substringPredicate])
            request.predicate = compoundPredicate
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try persistentContext.fetch(request)
        } catch {
            print("Error: \(error)")
        }

        self.tableView.reloadData()
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
            
            if (textField.text != nil) {
                
                let newItem = ToDoItem(context: self.persistentContext)
                newItem.title = textField.text!
                newItem.done = false
                newItem.itemCategory = self.selectedCategory!
                
                self.itemArray.append(newItem)
                
                self.saveItems(refreshItems: true)
            }
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
    }
}

