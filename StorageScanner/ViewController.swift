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
    var tableViewData = [Storage]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
    }

    override func viewDidAppear(_ animated: Bool) {
            
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Storage")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                tableViewData.append(data.value(forKey: "name") as! Storage)
            }
        }
        catch
            {
                print("Failed")
            }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell",
                                                    for: indexPath)
        cell.textLabel?.text = self.tableViewData[indexPath.row].name
        return cell
    }
    
    

    @IBAction func WhenAddButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Storage Area", message: "List the name of your new storage area", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Storage Name"
                    }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let textfield = alert.textFields![0]
            
            let newItem = Storage(context: self.context)
            newItem.entity.name = textfield.text
            
            do
            {
                try self.context.save()
            }
            catch
            {}
            
            self.tableView.reloadData()
            
            
//            if let storageText = textfield.text {
//                self.tableViewData.append(storageText)
//            }
            self.tableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
}

