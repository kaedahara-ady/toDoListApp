//
//  ViewController.swift
//  ToDoListApp
//
//  Created by OverPowerPWND Keeper83 on 1/11/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var toDoArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let addButton = UIBarButtonItem(image: UIImage(named: "add")?.withRenderingMode(.alwaysOriginal), style: .plain, target: ViewController.self, action: nil)
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
  
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let newItem = Item()
        newItem.title = "wake up"
        toDoArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "wash your face"
        toDoArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "make some breakfest"
        toDoArray.append(newItem3)
        
        loadItems()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = toDoArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        title = "ToDoList"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addTapped))
        navigationController?.navigationBar.backgroundColor = .systemYellow
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        cell.textLabel?.text = toDoArray[indexPath.row].title
        cell.imageView?.image = UIImage(systemName: "house")
        cell.imageView?.tintColor = .systemYellow
        
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        toDoArray[indexPath.row].done = !toDoArray[indexPath.row].done
        
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func addTapped(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "add new ToDo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textfield.text ?? "new record"
            
            self.toDoArray.append(newItem)
            self.tableView.reloadData()
            self.saveData()
        }
        alert.addTextField { alerTextfield in
            alerTextfield.placeholder = "Create new item"
            textfield = alerTextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(toDoArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error encoding toDo array, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf:  dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                toDoArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding toDo array, \(error)")
            }
        }
    }
    
}


