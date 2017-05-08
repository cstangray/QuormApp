//
//  FirstViewController.swift
//  QuormApp
//
//  Created by Charles Gray on 4/20/17.
//  Copyright © 2017 Charles Gray. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewController: UIViewController {

    
    var scriptures = List<Scripture>()
    var scriptureArray = Array<Any>()
    
    @IBOutlet weak var scriptureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let scriptureItems = RealmManager.shared.realm.objects(Scripture.self)
        
        scriptures = List<Scripture>()
        scriptures.append(objectsIn: scriptureItems)
        
        scriptureArray = Array(RealmManager.shared.realm.objects(Scripture.self))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadScripture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadScripture() {
        
        if scriptures.count > 0 {
            let selectedRandomIndex = Int(arc4random_uniform(UInt32(scriptureArray.count)))
        
            let scripture = scriptures[selectedRandomIndex]
        
            scriptureLabel.text = scripture.citation
        } else {
            scriptureLabel.text = ""
        }
        
    }
}

