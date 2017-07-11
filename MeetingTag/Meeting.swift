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
    var tags: [double_t]
    
    struct PropertyKey {
        static let title = "title"
        static let photo = "photo"
    }
    
    //MARK: Archiving Path
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meetings")
    
    init(title: String, photo: UIImage?) {
        self.title = title
        self.photo = photo
        self.tags = [double_t]()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the name for a meeting a object.", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        self.init(title: title, photo: photo)
    }
}
