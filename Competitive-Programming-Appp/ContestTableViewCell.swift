//
//  ContestTableViewCell.swift
//  Competitive-Programming-Appp
//
//  Created by ikbal kazar on 18/02/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import EventKit

class ContestTableViewCell: UITableViewCell {
    
    var contest: Contest = Contest()
    var savedEvents = [EKEvent]()
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet weak var contestNameLabel: UILabel!
    @IBOutlet var startDateTimeLabel: UILabel!
    
    @IBAction func addToCalendar(sender: AnyObject) {
        /*
            Issue:
            Causes app to crash when the access request is denied by the user from the settings. 
            May be it only happens if one change the access status while app was still working at the background
        */
    
        let store = EKEventStore()
        store.requestAccessToEntityType(.Event) {(granted, error) in
            if !granted {
                self.displayAlert("Error", message: "Access to calendar is needed")
                return
            }
            let event = EKEvent(eventStore: store)
            event.title = self.contest.event
            
            //Formats the start date-time
            var dateAsString = self.contest.startTime
            dateAsString.removeAtIndex(dateAsString.startIndex.advancedBy(10))
            let dateFormatter = NSDateFormatter()
            print(dateAsString)
            dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ss"
            event.startDate = dateFormatter.dateFromString(dateAsString)!
            
            //End date = start date + duration
            event.endDate = event.startDate.dateByAddingTimeInterval(self.contest.duration)
            
            event.calendar = store.defaultCalendarForNewEvents
            do {
                try store.saveEvent(event, span: .ThisEvent, commit: true)
                self.displayAlert("Done", message: "Contest is successfuly added to the calendar")
                self.savedEvents.append(event)
                //self.savedEventId = event.eventIdentifier //save event id to access this particular event later
            } catch {
                self.displayAlert("Error", message: "Can not add the contest to the calendar")
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func FormatForTable(strDate : String) -> String {
        print(strDate)
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let date = dateFormatter.dateFromString(strDate)
        print(date)
        dateFormatter.dateFormat = "MM/dd HH:mm"
        return dateFormatter.stringFromDate(date!)
    }

    func setContest(selectedContest: Contest) {
        contest = selectedContest
        cellImage.image = contest.getImage()
        contestNameLabel.text = contest.event
        
        startDateTimeLabel.text = FormatForTable(contest.localStart)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}