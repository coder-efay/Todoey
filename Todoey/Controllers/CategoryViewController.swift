//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yifei Guo on 1/15/18.
//  Copyright © 2018 Yifei Guo. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryArray : Results<Category>?   // how to change from ! to ?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       loadCategories() // it loads all the data fetched from the database after the view did load
    
    }
    //MARK: - TableView Datasource Methods

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1                // Nil Coalescing Operator
        //     category is optional, if it is not nil then have the count, if it is nil, turn to 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
            cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added"
        
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods -- what will happen if we tag the cell of the categories
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        
    }
        
        
    }
    
    
    
    
    //MARK: - Data Manipulation Methods

    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
            
        }
        catch {
            print("Error saving context \(error)")
        }
        
        
        tableView.reloadData()
    }
    
    // how to read data from CoreDatabase
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)

        tableView.reloadData() // always remember to reloaddata after you change the data
    }
    

    
    
    
    //MARK: - Add New Categories
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add New Categories", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Categories", style: .default) { (action) in
                // what will happen once the user clickes the Add Item Button on our UIAlert
                
                
                let newCategory = Category()
                newCategory.name = textField.text!
                
                self.save(category: newCategory)
                
            }
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Add A New Category"
                textField = alertTextField
            }
        
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        
        
        tableView.reloadData()
        
        
    }
    
    
    
    
    
    
    
    
    
}
