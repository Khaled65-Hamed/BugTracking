//
//  BugDetails.swift
//  BugTracking
//
//  Created by Khaled Hamed on 08/09/2024.
//

import Foundation

class BugDetails : NSObject , NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    
    func encode(with coder: NSCoder) {
        coder.encode(image, forKey: "image")
        coder.encode(imageURL, forKey: "imageURL")
        coder.encode(bugNotes, forKey: "bugNotes")
    }
    
    required convenience init?(coder: NSCoder) {
        let image = coder.decodeObject(forKey: "image") as? Data
        let imageURL = coder.decodeObject(forKey: "imageURL") as! String
        let bugNotes = coder.decodeObject(forKey: "bugNotes") as! String
        self.init(image: image, imageURL: imageURL, bugNotes: bugNotes)
    }
    
    
    internal init(image: Data? = nil, imageURL: String? = nil, bugNotes: String) {
        self.image = image
        self.imageURL = imageURL
        self.bugNotes = bugNotes
    }
    
    var image : Data?
    var imageURL : String?
    var bugNotes : String
}

