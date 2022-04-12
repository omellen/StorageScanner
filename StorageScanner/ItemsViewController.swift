//
//  ItemsViewController.swift
//  StorageScanner
//
//  Created by Olivia Mellen on 4/6/22.
//

import UIKit

class ItemsViewController: UIViewController {

    @IBOutlet weak var storageName: UILabel!
    var storageTitle: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageName.text = storageTitle
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
