//
//  BugDescriptionTableViewCellModel.swift
//  BugTracking
//
//  Created by Khaled Hamed on 08/09/2024.
//

import Foundation


struct BugDescriptionTableViewCellModel {
    
    var budDetails : BugDetails
    
    init(budDetails: BugDetails) {
        self.budDetails = budDetails
    }
}
