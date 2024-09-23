//
//  GoogleSheetManager.swift
//  BugTracking
//
//  Created by Khaled Hamed on 16/09/2024.
//

import Foundation
import GoogleAPIClientForREST

class GoogleSheetManager {
    
    static let shared = GoogleSheetManager()
    
    private init() {}
    
    func addDataToSpreedSheet() {
        
        // create an authentication factory using the access token & secret
        // make sure your token has access to GMail
        // do note, service accounts cannot access GMail unless with GSuite accounts
        let apiGate = CharactersApiGate()
        apiGate.addDataToGoogleSheet {
            
        } onFailure: { error in
            print(error)
        }

        
    }
}
