//
//  BugDetailsData.swift
//  BugTracking
//
//  Created by Khaled Hamed on 16/09/2024.
//

import Foundation

class BugDetailsData : NSObject , NSSecureCoding {
    internal init(bugModels: [BugDetails]? = nil) {
        self.bugModels = bugModels
    }
    
    static var supportsSecureCoding: Bool = true
    
    var bugModels : [BugDetails]?
    
    func encode(with coder: NSCoder) {
        coder.encode(bugModels, forKey: "bugModels")
    }
    
    required convenience init?(coder: NSCoder) {
        let  bugModels2 = coder.decodeObject(of: [BugDetails.self, NSArray.self], forKey: "bugModels") as? [BugDetails]
        self.init(bugModels: bugModels2)
    }
}
