//
//  SecondViewController.swift
//  QuormApp
//
//  Created by Charles Gray on 4/20/17.
//  Copyright © 2017 Charles Gray. All rights reserved.
//

import UIKit
import RealmSwift
import RealmResultsController


class AttendanceViewController: UITableViewController {

    var members = List<Member>()
    
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
        return members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        
        let member = members[indexPath.row]
        
        //cell.textLabel?.text = member.firstName + " " + member.familyName
        cell.textLabel?.text = member.fullName
        
        cell.accessoryView = createCheckBoxButton(member: member, indexPath: indexPath)

        //TODO: set state to current Realm value
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 30.0;//Choose your custom row height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = members[indexPath.row]
        try! RealmManager.shared.realm.write {
            member.completed = !member.completed
            let destinationIndexPath: IndexPath
            if member.completed {
                // move cell to bottom
                destinationIndexPath = IndexPath(row: members.count - 1, section: 0)
            } else {
                // move cell just above the first completed item
                let completedCount = RealmManager.shared.realm.objects(Member.self).filter("completed = true").count
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
            try! RealmManager.shared.realm.write {
                
                let member = members.remove(at: indexPath.row)
                RealmManager.shared.realm.delete(member)
                
                tableView.reloadData()
            }
        }
    }

    
    //MARK: instance methods
    
    
    func loadDataFromRealm() {
        
        let hpMembers = RealmManager.shared.realm.objects(Member.self).sorted(byKeyPath: "familyName")
        
        members = List<Member>() //reset obj
        members.append(objectsIn: hpMembers)
        
    }
    
    func setupUI() {
        title = "Attendance Record"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        //navigationItem.leftBarButtonItem = editButtonItem
    }
    
}

extension AttendanceViewController {
    


    func createCheckBoxButton (member: Member, indexPath: IndexPath) -> UIButton {
        
        let theButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width:20, height: 20))
        theButton.backgroundColor = .clear
        theButton.addTarget(self, action:#selector(self.attendanceButtonClicked), for: .touchUpInside)
        
        theButton.setImage(UIImage(named: "checkBoxPlain"), for: UIControlState.normal)
        theButton.setImage(UIImage(named: "checkBoxChecked"), for: UIControlState.selected)
        
        theButton.isSelected = member.autoAttend
    
        
        theButton.tag = indexPath.row
        

        
        return theButton
        
        
    }
    
    func attendanceButtonClicked(sender:UIButton) {
        sender.isSelected = sender.isSelected ? false : true
        
        try! RealmManager.shared.realm.write {
            
            let member = members[sender.tag]
            
            //member.autoAttend = sender.isOn
        }
    }
    
    func add() {
        
    }

    
    func switchValueDidChange(sender:UISwitch!){
        
        try! RealmManager.shared.realm.write {
            
            let member = members[sender.tag]
            
            member.autoAttend = sender.isOn
            
        }
    }
    
    
    
}

