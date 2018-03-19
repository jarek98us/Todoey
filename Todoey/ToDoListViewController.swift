//
//  ViewController.swift
//  Todoey
//
//  Created by Jarek on 19/03/2018.
//  Copyright © 2018 Jarek. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demagorgon"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storedArray = defaults.array(forKey: "ToDoListArray") as? [String] {
            print(storedArray)
            itemArray = storedArray
        }
        //
        // Do any additional setup after loading the view, typically from a nib.
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
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row), item: \(itemArray[indexPath.row])")
        
        let isChecked = tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        tableView.cellForRow(at: indexPath)?.accessoryType = isChecked ? .none : .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK - Add new Items
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
                self.itemArray.append(textField.text!)
                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
    }
}

