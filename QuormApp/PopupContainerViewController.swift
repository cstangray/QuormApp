//
//  PopupContainerViewController.swift
//  QuormApp
//
//  Created by Charles Gray on 5/5/17.
//  Copyright © 2017 Charles Gray. All rights reserved.
//

import UIKit
import FSCalendar

protocol PopupContainerViewControllerDelegate {
    func calendarDidSelectDate(vc: PopupContainerViewController,  selectedDate: Date)
}

class PopupContainerViewController: UIViewController, FSCalendarDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    let sanityCalendar = NSCalendar(calendarIdentifier: .gregorian)

    
    var delegate : PopupContainerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        
        //TODO: sanity check that date is a sunday == 1
        
        let sanityComponents = sanityCalendar?.components(.weekday, from: date)

        let weekDay = sanityComponents?.weekday
        
        if let delegate = self.delegate {
            if weekDay == 1 {
                delegate.calendarDidSelectDate(vc: self, selectedDate: date)
            } else {
                print( "invalid date selected")
            }
        }
    }

}
