//
//  Meeting.swift
//  MeetingTag
//
//  Created by Jerry XU on 10/7/2017.
//  Copyright © 2017 Jerry XU. All rights reserved.
//

import UIKit
import  os.log

class Meeting: NSObject, NSCoding {
    //MARK: Properties
    
    var title: String
    var photo: UIImage?
    var tags: [Int]
    
    struct PropertyKey {
        static let title = "title"
        static let photo = "photo"
        static let tags = "tags"
    }
    
    //MARK: Archiving Path
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meetings")
    
    init(title: String, photo: UIImage?, tags: [Int]? ) {
        self.title = title
        self.photo = photo
        self.tags = [Int]()
        if let initTags = tags
        {
            self.tags += initTags
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(tags, forKey: PropertyKey.tags)
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the name for a meeting a object.", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let tags = aDecoder.decodeObject(forKey: PropertyKey.tags) as? [Int]
        self.init(title: title, photo: photo, tags: tags)
    }
}
