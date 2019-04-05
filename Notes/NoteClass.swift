//
//  NoteClass.swift
//  notes
//
//  Created by Isaac Raval on 4/2/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

class Note: NSObject, NSCoding {
    
    var noteName: String
    var noteContents: String
    var date: String
    
    
    init(noteName: String, noteContents: String, date: String) {
        self.noteName = noteName
        self.noteContents = noteContents
        self.date = date
    }
   required convenience init(coder aDecoder: NSCoder) {
        let noteName = aDecoder.decodeObject(forKey: "noteName") as! String
        let noteContents = aDecoder.decodeObject(forKey: "noteContents") as! String
        let date = aDecoder.decodeObject(forKey: "date") as! String
        self.init(noteName: noteName, noteContents: noteContents, date: date)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(noteName, forKey: "noteName")
        aCoder.encode(noteContents, forKey: "noteContents")
        aCoder.encode(date, forKey: "date")
    }
    
    
}
