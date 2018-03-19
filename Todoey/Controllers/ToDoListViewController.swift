//
//  ViewController.swift
//  Todoey
//
//  Created by Jarek on 19/03/2018.
//  Copyright © 2018 Jarek. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [ToDoItem]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItems()
    }

    
    // MARK - Add new Items
    fileprivate func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    fileprivate func loadItems() {
        do {
            let data = try Data(contentsOf: self.dataFilePath!)
            let decoder = PropertyListDecoder()
            
            itemArray = try decoder.decode([ToDoItem].self, from: data)
        } catch {
            print("Error decoding array, \(error)")
        }
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
                let newItem = ToDoItem(textField.text!)
                
                self.itemArray.append(newItem)
                
                self.saveItems()
            }
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
    }
}

