//
//  ShoppingTableViewController.swift
//  ShoppingList
//
//  Created by Wu Wan Lun on 2019/8/9.
//  Copyright © 2019 Wu Wan Lun. All rights reserved.
//

import UIKit

class ShoppingTableViewController: UITableViewController {
    
    var shoppingItems = [String]()
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        popUpAlertWithDefault(nil, withCompletionHandler: {
            (success:Bool, result:String?) in
            if success == true {
                if let okResult = result {
                    self.shoppingItems.append(okResult)
                    //tableView.reloadData()
                    let insertInfoAtThisIndexPath = IndexPath(row: self.shoppingItems.count-1, section: 0)
                    self.tableView.insertRows(at: [insertInfoAtThisIndexPath], with: .automatic)
                    self.saveList()
                }
            }
        })
    }
    
    func saveList() {
        UserDefaults.standard.set(shoppingItems, forKey: "list")
    }
        
    func loadList() {
        if let okList = UserDefaults.standard.stringArray(forKey: "list"){
            shoppingItems = okList
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        popUpAlertWithDefault(shoppingItems[indexPath.row], withCompletionHandler:  {
            (success:Bool, result:String?) in
            if success == true {
                if let okResult = result {
                    self.shoppingItems[indexPath.row] = okResult
                    self.tableView.reloadData()
                    self.saveList()
                }
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
           shoppingItems.remove(at: indexPath.row)
           saveList()
           tableView.reloadData()
        }
    }
    
    func popUpAlertWithDefault(_ defaultValue: String?,withCompletionHandler handler: @escaping (Bool, String?) -> ()) {
    let alert = UIAlertController(title: "What do you want to do?", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (textfield) in
            textfield.placeholder = "Add here"
            textfield.text = defaultValue
        })
       let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            //What to do after pressing ok button
            //Take out text from textfield
            if let inputText = alert.textFields?[0].text {
            if inputText != "" {
                //... Append inputText to shopping list
                handler(true,inputText)
            }else{
                handler(false,nil)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action) in
            handler(false,nil)
        })
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    loadList()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shoppingItems[indexPath.row]
        return cell
    }
}
