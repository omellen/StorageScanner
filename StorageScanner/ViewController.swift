//
//  ViewController.swift
//  StorageScanner
//
//  Created by Olivia Mellen on 3/18/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var storages: [Storage] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var selectedStorage: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
    }

    override func viewWillAppear(_ animated: Bool)
    {
        getData()
        tableView.reloadData()
    }
    
    
    @IBAction func WhenAddButtonPressed(_ sender: Any)
    {
        let alert = UIAlertController(title: "Add Storage Area", message: "List the name of your new storage area", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Storage Name"
        }
        
//        alert.addTextField { (textfield) in
//            textfield.placeholder = "Quantity"
//        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let storage = Storage(context: context)
            
            let nameTFT = alert.textFields?[0].text
            storage.name = nameTFT
//            let Quantity = alert.textFields?[1].text
//            storage.quantity = Quantity
            
            self.storages.append(storage)
            self.tableView.reloadData()
            appDelegate.saveContext()
        }
        alert.addAction(addAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getData()
    {
        if let myStorages = try? appDelegate.persistentContainer.viewContext.fetch(Storage.fetchRequest())
        {
            storages = myStorages
        }
        else
        {
            printContent("error in fetching data")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.storages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = self.storages[indexPath.row].name
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            let alert = UIAlertController(title: "", message: "Edit list item", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.text = self.storages[indexPath.row].name
            }
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { updateAction in
                let storage = self.storages[indexPath.row]
                self.storages[indexPath.row].name = alert.textFields![0].text
                storage.name = alert.textFields![0].text
                try! self.appDelegate.persistentContainer.viewContext.save()
                self.getData()
                
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { action, indexPath in
            let storage = self.storages[indexPath.row]
            self.appDelegate.persistentContainer.viewContext.delete(storage)
            try! self.appDelegate.persistentContainer.viewContext.save()
            self.getData()
            tableView.reloadData()
        }
        
        return [deleteAction, editAction]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedStorage = "\(storages[indexPath.row].name!)"
        self.performSegue(withIdentifier: "ItemsSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! ItemsViewController
        vc.storageTitle = selectedStorage
    }
    
}

