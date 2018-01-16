//
//  ViewController.swift
//  Todoey
//
//  Created by Yifei Guo on 1/13/18.
//  Copyright © 2018 Yifei Guo. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    
    var selectedCategory : Category? {
        didSet{
         loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        print (dataFilePath)
        
        
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none // Ternary operator ==> value = condition ? valueIfTure : valueIfFalse
            
        } else{
            cell.textLabel?.text = "No Items Added"
        }
       
        return cell
    }
    
    //MARK - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            
            do{
                try realm.write{
                    item.done = !item.done
                }
                } catch{
                    print("Error saving done status, \(error)")
                }
        }
        
        tableView.reloadData()
       
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clickes the Add Item Button on our UIAlert
            
            if let currentCategory = self.selectedCategory {
                
                do {
                     // use realm.write to update the data in the database
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
                }
                }catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
    
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        tableView.reloadData()

    }
    // MARK: - Model Manipulation Methods
    
    
    
    // how to read data from CoreDatabase
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        

        tableView.reloadData() // always remember to reloaddata after you change the data
    }


}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // how to query data using filter
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            // make the search bar and keyboard dismissed
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }





}




















