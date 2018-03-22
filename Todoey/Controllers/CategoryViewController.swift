//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jarek on 20/03/2018.
//  Copyright © 2018 Jarek. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.getCell(withIdentifier: "CategoryCell", for: indexPath)
  
        if let category = categories?[indexPath.row]
        {
            cell.textLabel?.text = category.name
            let backgroundColor = UIColor(hexString: category.colorHex)!
            let foregroundColor = ContrastColorOf(backgroundColor, returnFlat: true)

            cell.backgroundColor = backgroundColor
            cell.textLabel!.textColor = foregroundColor
        }
        return cell
    }
    
    // MARK: Data Manipulation Methods
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    fileprivate func save(category: Category, refreshItems: Bool = false) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context: \(error)")
        }
        
        if (refreshItems) {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (newTextField) in
            newTextField.placeholder = "Create new category"
            textField = newTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) {
            (action) in
            
            if (textField.text != nil) {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.colorHex = UIColor.randomFlat.hexValue()
                
                self.save(category: newCategory, refreshItems: true)
            }
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row), item: \(categories![indexPath.row])")

        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = (segue.destination as! ToDoListViewController)
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row] ?? nil
        }
    }
    
    override func deleteRow(rowIndex: Int) {
        if let category = self.categories?[rowIndex] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("Error when deleting category: \(error)")
            }

        }
    }
}

