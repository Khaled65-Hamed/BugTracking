//
//  CharacterResponseModelData.swift
//  BugTracking
//
//  Created by Khaled Hamed on 18/09/2024.
//

import Foundation

class CharacterResponseModelData : Codable {
    
    var name : String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}
