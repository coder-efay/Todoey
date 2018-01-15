//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yifei Guo on 1/15/18.
//  Copyright © 2018 Yifei Guo. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       loadCategories() // it loads all the data fetched from the database after the view did load
    
    }
    //MARK: - TableView Datasource Methods

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
            cell.textLabel?.text = categoryArray[indexPath.row].name
        
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods -- what will happen if we tag the cell of the categories
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        
    }
        
        
    }
    
    
    
    
    //MARK: - Data Manipulation Methods

    func saveCategoreis () {
        
        do {
            try context.save()
            
        }
        catch {
            print("Error saving context \(error)")
        }
        
        
        tableView.reloadData()
    }
    
    // how to read data from CoreDatabase
    func loadCategories() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categoryArray = try context.fetch(request)   // whenwever this is a chance to throw error on your code, you need to use do-try catch
        } catch {
            print ("Error fetching data from context \(error)")
        }
        
        tableView.reloadData() // always remember to reloaddata after you change the data
    }
    

    
    
    
    //MARK: - Add New Categories
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add New Categories", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Categories", style: .default) { (action) in
                // what will happen once the user clickes the Add Item Button on our UIAlert
                
                
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                self.categoryArray.append(newCategory)
                
                self.saveCategoreis()
                
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
