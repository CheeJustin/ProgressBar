//
//  Event.swift
//  ProgressBar
//
//  Created by Justin Chee on 2015-03-23.
//  Copyright (c) 2015 Justin Chee. All rights reserved.
//

import Foundation

class Event
{
    var title: String
    
    init(name: String)
    {
        self.title = name
    }
    
    class func eventsWithJSON(allResults: NSArray) -> [Event] {
        
        // Create an empty array of Albums to append to from this list
        var events = [Event]()
        
        // Store the results in our table data array
        if allResults.count>0 {
            
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result in allResults {
                
                var name = result["extract"] as? String
                if  name == nil {
                    
                }
                
                var newEvent = Event(name: name!)
                events.append(newEvent)
            }
        }
        return events
    }
}