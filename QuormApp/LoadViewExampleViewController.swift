//
//  LoadViewExampleViewController.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 10/17/16.
//  Copyright © 2016 wenchao. All rights reserved.
//

import UIKit
import FSCalendar

protocol LoadViewExampleViewControllerDelegate {
    func calendarDidSelectDate(date: NSDate)
}

class LoadViewExampleViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    private weak var calendar: FSCalendar!
    var calendarFrame = CGRect()
    var delegate: LoadViewExampleViewControllerDelegate
    

//    init(){
//        super.init()
//        
//    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCalendar()
    }
    
    func loadCalendar() {
        
        //let view = UIView(frame: UIScreen.main.bounds)

        let view = UIView(frame: self.calendarFrame)
        //view.backgroundColor = UIColor.groupTableViewBackground

        self.view = view
        
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
        let calendarFrame = CGRect(x: 0, y: 200.0, width: 500.0, height: height)
        //let calendar = FSCalendar(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY, width: self.view.bounds.width, height: height))
        let calendar = FSCalendar(frame: calendarFrame)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor.white
        self.view.addSubview(calendar)
        self.calendar = calendar

    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }

}
