//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jarek on 20/03/2018.
//  Copyright © 2018 Jarek. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let persistentContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        cell.accessoryType = .detailButton
        
        return cell
    }
    
    // MARK: Data Manipulation Methods
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try persistentContext.fetch(request)
        } catch {
            print("Error: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    fileprivate func saveCategories(refreshItems: Bool = false) {
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
                
                let newCategory = Category(context: self.persistentContext)
                newCategory.name = textField.text!

                self.categoryArray.append(newCategory)
                
                self.saveCategories(refreshItems: true)
            }
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row), item: \(categoryArray[indexPath.row])")

        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = (segue.destination as! ToDoListViewController)
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
}
