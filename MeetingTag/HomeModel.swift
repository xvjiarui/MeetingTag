//
//  HomeModel.swift
//  MeetingTag
//
//  Created by Jerry XU on 13/7/2017.
//  Copyright © 2017 Jerry XU. All rights reserved.
//

import Foundation

import UIKit

protocol HomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class HomeModel: NSObject {
    
    //properties
    
    weak var delegate: HomeModelProtocol!
    
    let urlPath = "https://minutes.000webhostapp.com/service.php"
    func downloadItems() {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)

//        let defaultSession = URLSes
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
                print(error!)
            }else {
                print("Data downloaded")
                self.parseJSON(data!)
            }
            
        }
        
        task.resume()
    }
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        let meetings = NSMutableArray()
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let title = jsonElement["Title"] as? String
            {
//                let meeting = Meeting(title: title, photo: nil, tags: [Int]())
//                meetings.add(meeting)
                print(title)
            }
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: meetings)
            
        })
    }
    
}
