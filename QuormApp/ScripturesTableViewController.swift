//
//  ScripturesTableViewController.swift
//  QuormApp
//
//  Created by Charles Gray on 4/25/17.
//  Copyright © 2017 Charles Gray. All rights reserved.
//

import UIKit
import RealmSwift
import RealmResultsController


final class ScriptureList: Object {
    dynamic var text = ""
    dynamic var id = ""
    let items = List<Scripture>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class Scripture: Object {
    dynamic var citation = ""
    dynamic var source = ""

}


class ScripturesTableViewController: UITableViewController {
    
    //var members = List<Member>()
    //var scriptures = List<Scripture>()
    
    var scriptures = List<Scripture>()
    
    
    //var realm =  RealmManager.shared.realm
    //fileprivate var resultController:RealmResultsController<Member>
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromRealm()
        tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptures.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        
        let scripture = scriptures[indexPath.row]
        
        cell.textLabel?.text = scripture.citation
        
        cell.detailTextLabel?.text = scripture.source
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.detailTextLabel?.alpha = 1.0
        
        return cell
    }
    
    
    //MARK: instance methods
    
    
    func loadDataFromRealm() {
//        if realm == nil {
//            realm = RealmManager.shared.realm
//        }
        
        let scriptureItems = RealmManager.shared.realm.objects(Scripture.self)
        
        scriptures = List<Scripture>()
        scriptures.append(objectsIn: scriptureItems)
        
        //members.append(objectsIn: hpMembers)

    }
    
    func setupUI() {
        title = "Chosen Scriptures"
                
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.leftBarButtonItem = editButtonItem
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension ScripturesTableViewController {
    func add() {
        let alertController = UIAlertController(title: "New Scripture", message: "Enter the following", preferredStyle: .alert)
        var tfAlertCitation: UITextField!
        var tfAlertSource: UITextField!

        
        alertController.addTextField { detailTextField in
            tfAlertSource = detailTextField
            detailTextField.placeholder = "Source"
        }

        alertController.addTextField { textField in
            tfAlertCitation = textField
            textField.placeholder = "Scripture Citation"
        }
        
        
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            guard let citation = tfAlertCitation.text , !citation.isEmpty else { return }
            guard let source = tfAlertSource.text , !source.isEmpty else { return }
            
            
            try! RealmManager.shared.realm.write {
                let newScripture = Scripture(value: ["citation": citation , "source": source])
                
                self.scriptures.append(newScripture)
                
                RealmManager.shared.realm.add(newScripture)
                
                self.tableView.reloadData()
                
            }
            
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }

}
