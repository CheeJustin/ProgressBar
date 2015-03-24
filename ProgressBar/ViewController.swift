//
//  ViewController.swift
//  ProgressBar
//
//  Created by Justin Chee on 2015-03-23.
//  Copyright (c) 2015 Justin Chee. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var startCount: UIButton!
    
    @IBOutlet weak var dateInfo: UILabel!
    
    var range: Int = 0
    var startYear = 0
    var endYear = 0
    var yearRange = 0
    var progress = 0
    var curProgress = 0
    
    var url : String = "http://en.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&titles="
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        progressBar.setProgress(0, animated: true)
        
        let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        let date = NSDate()
        let components = NSCalendar.currentCalendar().components(flags, fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        
        startYear = components.year
        println(components.year)
        yearRange = 200
        endYear = startYear - range
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    var counter:Int = 0 {
        didSet {
            let fractionalProgress = Float(counter) / 100.0
            let animated = counter != 0
            
            progressBar.setProgress(fractionalProgress, animated: animated)
            progressLabel.text = ("\(counter)%")
        }
    }

    @IBAction func startCount(sender: AnyObject)
    {
        progressLabel.text = "0%"
        self.counter = 0
        for i:UInt32 in 0..<15
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
            {
                usleep(i*500000)
                dispatch_async(dispatch_get_main_queue(),
                {
                    self.counter++
                    
                    self.progressLabel.text = ("\(self.counter)%")
                        
                    if self.counter % 5 == 0
                    {
                        self.progress = self.counter * 200 / 100
                        self.curProgress = self.startYear - self.progress
                        self.dateInfo.text = String(self.curProgress)
                        
                        
                        var curUrl : String = self.url + String(self.curProgress)
                        
                        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: curUrl)!)
                        { (data, response, error) in
                            var parsedJSON = self.parseJSON(self.getJSON(curUrl))
                            
                            if let element = parsedJSON["query"]{
                                if let query = element["pages"]{
                                    println(query)
                                }
                            }
                            //let element: AnyObject? = parsedJSON["query"]
                            //println(element)
                        }.resume()
                        
//                        var request : NSMutableURLRequest = NSMutableURLRequest()
//                        request.URL = NSURL(string: curUrl)
//                        request.HTTPMethod = "GET"
//                        
//                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//                            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
//                            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
//                            
//                            if (jsonResult != nil) {
//                                println(jsonResult)
//                            } else {
//                                // couldn't load JSON, look at error
//                                println("NO RESULT")
//                            }
//                            
//                            
//                        })
                        
                    }
                    
                    return
                })
            })
        }
    }
    
    func getJSON(urlToRequest: String) -> NSData {
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary {
        var error: NSError?
        var events: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        return events
    }

}

