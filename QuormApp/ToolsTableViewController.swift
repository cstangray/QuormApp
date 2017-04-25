//
//  ToolsTableViewController.swift
//  QuormApp
//
//  Created by Charles Gray on 4/23/17.
//  Copyright © 2017 Charles Gray. All rights reserved.
//

import UIKit

class ToolsTableViewController: UITableViewController {
    
    let titleArray = ["Scriptures", "moreStuff"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        title = "App Tools"
        
        //        let dynamicView=UIView(frame: CGRect(x: self.view.center.x-50.0, y: self.view.center.y, width: 100.0, height: 100.0))
        //        dynamicView.backgroundColor=UIColor.yellow
        //        dynamicView.layer.cornerRadius=25
        //        dynamicView.layer.borderWidth=2
        //        dynamicView.layer.borderColor=UIColor.lightGray.cgColor
        //        self.view.addSubview(dynamicView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        //navigationItem.leftBarButtonItem = editButtonItem
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        
        let itemTitle = titleArray[indexPath.row]
        
        cell.textLabel?.text = itemTitle
        
        
        if indexPath.row < titleArray.count - 1 {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(ScripturesTableViewController(), animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
