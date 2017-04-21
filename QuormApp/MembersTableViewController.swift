//
//  MembersTableViewController.swift
//  QuormMaster
//
//  Created by Charles Gray on 4/16/17.
//  Copyright © 2017 Charles Gray. All rights reserved.
//

import UIKit

import RealmSwift


final class MemberList: Object {
    dynamic var text = ""
    dynamic var id = ""
    let items = List<Member>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class Member: Object {
    dynamic var firstName = ""
    dynamic var familyName = ""
    dynamic var fullName = ""
    dynamic var spouseName = ""
    dynamic var autoAttend = false
    dynamic var completed = false
    

    
}


class MembersTableViewController: UITableViewController {
    
    var members = List<Member>()
    
    var realm: Realm!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        setupUI()
        
        loadDataFromRealm()

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
        return members.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        
        let member = members[indexPath.row]
        
        //cell.textLabel?.text = member.firstName + " " + member.familyName
        cell.textLabel?.text = member.fullName

        //cell.textLabel?.alpha = item.completed ? 0.5 : 1
        cell.detailTextLabel?.text = member.spouseName
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.detailTextLabel?.alpha = 1.0
        
        cell.accessoryView = createSwitch(member: member, indexPath: indexPath)
        //TODO: set state to current Realm value
        

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0;//Choose your custom row height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = members[indexPath.row]
        try! realm?.write {
            member.completed = !member.completed
            let destinationIndexPath: IndexPath
            if member.completed {
                // move cell to bottom
                destinationIndexPath = IndexPath(row: members.count - 1, section: 0)
            } else {
                // move cell just above the first completed item
                let completedCount = realm.objects(Member.self).filter("completed = true").count
                destinationIndexPath = IndexPath(row: members.count - completedCount - 1, section: 0)
            }
            members.move(from: indexPath.row, to: destinationIndexPath.row)
        }
        
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        try! members.realm?.write {
            members.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                
                let member = members.remove(at: indexPath.row)
                self.realm.delete(member)
                
                tableView.reloadData()
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
    
    
    //MARK: instance methods
    
    
    func loadDataFromRealm() {
        if realm == nil {
            realm = try! Realm()
        }
        
        let hpMembers = realm.objects(Member.self)
        members.append(objectsIn: hpMembers)
        
        //items.append(Task(value: ["text": "My First Task"]))
        
        
    }
    
    func setupUI() {
        title = "Quorm Members"
        
        //        let dynamicView=UIView(frame: CGRect(x: self.view.center.x-50.0, y: self.view.center.y, width: 100.0, height: 100.0))
        //        dynamicView.backgroundColor=UIColor.yellow
        //        dynamicView.layer.cornerRadius=25
        //        dynamicView.layer.borderWidth=2
        //        dynamicView.layer.borderColor=UIColor.lightGray.cgColor
        //        self.view.addSubview(dynamicView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.leftBarButtonItem = editButtonItem
    }
    


}

extension MembersTableViewController {
    
    func add() {
        let alertController = UIAlertController(title: "New Member", message: "Enter Member Name", preferredStyle: .alert)
        var tfAlertFirstName: UITextField!
        var tfAlertFamilyName: UITextField!
        var tfAlertSpouseName: UITextField!

        
        
        alertController.addTextField { textField in
            tfAlertFirstName = textField
            textField.placeholder = "First Name"
        }
        
        alertController.addTextField { detailTextField in
            tfAlertFamilyName = detailTextField
            detailTextField.placeholder = "Last Name"
        }
        
        alertController.addTextField { spouseTextField in
            tfAlertSpouseName = spouseTextField
            spouseTextField.placeholder = "Spouse Name"
        }

        
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            guard let firstName = tfAlertFirstName.text , !firstName.isEmpty else { return }
            guard let lastName = tfAlertFamilyName.text , !lastName.isEmpty else { return }
            guard let spouseName = tfAlertSpouseName.text , !spouseName.isEmpty else { return }

            
            
            try! self.realm?.write {
                let newMember = Member(value: ["firstName": firstName , "familyName": lastName, "spouseName": spouseName, "fullName" : firstName + " " + lastName])

                self.members.append(newMember)
                
                self.realm.add(newMember)
                
                self.tableView.reloadData()
                
            }
            
        })
        
        //alertController.view.addSubview(createSwitch())
        
//        let margin:CGFloat = 10.0
//        //let rect = CGRect(x: margin, y: margin, width: alertController.view.frame.size.width - margin * 4.0, height: 120)
//        
//        let rect = CGRect(x: 0, y: 130, width: 270, height: 25)
//
//        let customView = UIView(frame: rect)
//        
//        customView.backgroundColor = .green
//        
//        alertController.view.addSubview(customView)

        

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    

    func createSwitch (member: Member, indexPath: IndexPath) -> UISwitch{
        
        let switchControl = UISwitch(frame:.zero)
        
        switchControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        switchControl.isOn = member.autoAttend
        
        //switchControl.setOn(true, animated: false)
        
        switchControl.tag = indexPath.row // for detect which row switch Changed

        switchControl.addTarget(self, action: #selector(switchValueDidChange(sender:)), for: .valueChanged)
        
        
        
        return switchControl
    }
    
    func switchValueDidChange(sender:UISwitch!){
        
        try! realm.write {
            
            let member = members[sender.tag]
            
            member.autoAttend = sender.isOn

        }
    }

    
    
}
