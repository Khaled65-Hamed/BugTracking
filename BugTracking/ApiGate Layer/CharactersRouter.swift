//
//  CharactersRouter.swift
//  RickAndMorty
//
//  Created by Khaled Hamed on 27/01/2024.
//

import Foundation

class CharactersRouter : BaseAPIRouter{
    
     init(method: HTTPMethod, path: String, bodyParams: JSONDICTIONARY? = nil, queryParams: JSONDICTIONARY? = nil, requestHeaders: [String : Any]? = nil) {
        
        let baseUrl = BaseUrl
        super.init(baseURLString: baseUrl, method: method, path: path, queryParams: queryParams)
        
    }
}
