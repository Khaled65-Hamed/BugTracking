//
//  CharactersApiGate.swift
//  RickAndMorty
//
//  Created by Khaled Hamed on 27/01/2024.
//

import Foundation


class CharactersApiGate : BaseAPIHandler {
    
    private enum EndPoints : String {
        case getCharacters = "%@/%S/sheet1!A1:D5"
    }
    
    private enum Attributes : String {
        case PageNumber = "valueInputOption"
    }
    
    func addDataToGoogleSheet(onSuccess : @escaping () -> Void , onFailure : @escaping (BaseNetworkError) -> Void) {
        /*
         {
           "range": "Sheet1!A1:D5",
           "majorDimension": "ROWS",
           "values": [
             ["Item", "Cost", "Stocked", "Ship Date"],
             ["Wheel", "$20.50", "4", "3/1/2016"],
             ["Door", "$15", "2", "3/15/2016"],
             ["Engine", "$100", "1", "3/20/2016"],
             ["Totals", "=SUM(B2:B4)", "=SUM(C2:C4)", "=MAX(D2:D4)"]
           ],
         }
         */
        var params : [String : AnyObject] = [:]
        //params["range"] = "Sheet1!A1:D5" as AnyObject
        params["majorDimension"] = "ROWS" as AnyObject
        let values = [
            ["Item", "Cost", "Stocked", "Ship Date"],
            ["Wheel", "$20.50", "4", "3/1/2016"],
            ["Door", "$15", "2", "3/15/2016"],
            ["Engine", "$100", "1", "3/20/2016"],
            ["Totals", "=SUM(B2:B4)", "=SUM(C2:C4)", "=MAX(D2:D4)"]
          ]
        //params["values"] = values as AnyObject
        
        var fullEndpoint = EndPoints.getCharacters.rawValue.replacingOccurrences(of: "%@", with: "1h4OuP_FW42lzZjH0tkfqHMHX5TrnEM7Th6NuTpJx2yI")
        
        let result = fullEndpoint.replacingOccurrences(of: "%S", with: "Stocked")
        
        let router = CharactersRouter(method: .post, path: result, bodyParams: params)
        
        self.performNetworkRequest(forRouter: router, jsonDecoder: JSONDecoder()) { (result: Result<CharacterResponseModelData, BaseNetworkError>) in
            switch result {
            case .success(let response):
                print(response)
                onSuccess()
            case .failure(let error):
                onFailure(error)
                print(error)
                
            }
        }
    }
}
