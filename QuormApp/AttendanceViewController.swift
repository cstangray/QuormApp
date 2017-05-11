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
    var rrc: RealmResultsController<TaskModelObject, TaskObject>?

    
    let dateFormatter = DateFormatter()
    var rollDate:Date?
    let pageTitle = "Attendace Record"


    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        setupUI()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //loadDataFromRealm()
        //tableView.reloadData()
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(dateTypeSelector))
        //navigationItem.leftBarButtonItem = editButtonItem
        
        self.setupTitleView()
    }
    
}

extension AttendanceViewController : UIPopoverPresentationControllerDelegate, PopupContainerViewControllerDelegate {
    


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
    
    func dateTypeSelector() {
        let alertController = UIAlertController(title: "Date Selector", message: "Select Today or Previous Attendance Roll", preferredStyle: .alert)
        
        
        alertController.addAction(UIAlertAction(title: "Today", style: .default) { _ in
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveRecord))

            self.rollDate = Date()
            self.setupTitleView()
            self.loadDataFromRealm()
            self.tableView.reloadData()
        
            
        })
        
        alertController.addAction(UIAlertAction(title: "Previous Roll", style: .default) { _ in
            
            self.add()
            
        })

        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func add() {
        
        
        //let frame = CGRect(x: 0, y: 100, width: 100.0, height: 100.0)

        let vc = PopupContainerViewController()
        
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        
        guard let popoverPresentationController = vc.popoverPresentationController else {
            return
        }
        
        
        
        popoverPresentationController.permittedArrowDirections = [.up, .down]
        popoverPresentationController.delegate = self
        popoverPresentationController.sourceView = self.view
        //popoverPresentationController.sourceRect = frame//cell.frame.offsetBy(dx: 0, dy: 50 + height)
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func calendarDidSelectDate(vc: PopupContainerViewController,  selectedDate: Date) {
        vc.dismiss(animated: true, completion: {
            self.assignDate(selectedDate: selectedDate)

        })
    }
    
    func assignDate(selectedDate: Date) {
        self.rollDate = selectedDate
        self.setupTitleView()
        
        //TODO:
        // select previous attendance records from Realm
        // reload table data (read-only IF previous)
        
        //print(self.dateFormatter.string(from:selectedDate as Date))
    }
    
    func setupTitleView() {
        self.title = pageTitle
        
        guard let titleDate = rollDate else { return }
        
        let displayDate = self.dateFormatter.string(from:titleDate)

        let topText = NSLocalizedString(pageTitle, comment: "Attendance")
        
        let bottomText = NSLocalizedString(displayDate, comment: "recordDate")
        
        
        let titleParameters:[String:Any] = [NSForegroundColorAttributeName : UIColor.black,
                                            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18)]
        let subtitleParameters:[String:Any] = [NSForegroundColorAttributeName : UIColor.lightGray,
                                               NSFontAttributeName : UIFont.systemFont(ofSize:12)]
        
        let title = NSMutableAttributedString(string: topText, attributes: titleParameters)
        let subtitle = NSAttributedString(string: bottomText, attributes: subtitleParameters)
        
        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)
        
        let size = title.size()
        let width = size.width
        guard let height = navigationController?.navigationBar.frame.size.height else {return}
        
        let titleLabel = UILabel(frame: CGRect(x:0,y:0, width:Int(width), height:Int(height)))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        navigationItem.titleView = titleLabel
    }
    
    func saveRecord() {
        print("save record")
        
        try! RealmManager.shared.realm.write {
            for(idx,member) in members.enumerated() {
                let task = TaskModelObject()
                task.id = member.id
                task.name = "Task-\(idx)"
                task.attended = true
                task.meetingDate = self.rollDate!
                task.user = member
                RealmManager.shared.realm.add(task)
            }
        }

    }
}

