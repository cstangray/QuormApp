//
//  CalendarViewController.swift
//  QuormApp
//
//  Created by Charles Gray on 5/4/17.
//  Copyright © 2017 Charles Gray. All rights reserved.
//

import UIKit
import FSCalendar

protocol CalendarViewControllerDelegate {
    func calendarDidSelectDate(date: NSDate)
}

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    
    @IBOutlet weak var calendar: FSCalendar!
    //private weak var calendar: FSCalendar!
    //var calendarFrame = CGRect()
    var delegate : CalendarViewControllerDelegate?
    
    init() {
        //super.init()
        super.init(nibName: "CalendarViewContoller", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCalendar()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCalendar() {
        
        //let view = UIView(frame: UIScreen.main.bounds)
        
        //let view = UIView(frame: self.calendarFrame)
        //view.backgroundColor = UIColor.groupTableViewBackground
        
        //self.view = view
        
        //let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
        //let calendarFrame = CGRect(x: 0, y: 200.0, width: 500.0, height: height)
        //let calendar = FSCalendar(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY, width: self.view.bounds.width, height: height))
        //let calendar = FSCalendar(frame: self.calendar.frame)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor.white
        //self.view.addSubview(calendar)
        //self.calendar = calendar
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }

    

}
