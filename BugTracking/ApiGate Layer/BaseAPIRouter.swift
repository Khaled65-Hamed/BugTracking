//
//  BaseAPIRouter.swift
//  RickAndMorty
//
//  Created by Khaled Hamed on 27/01/2024.
//

import Foundation

public typealias JSONDICTIONARY = [String : Any]

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
}

open class BaseAPIRouter {
    let baseURLString: String
    
    let method : HTTPMethod
    
    let path : String
    
    let bodyParams : JSONDICTIONARY?
    
    let queryParams : JSONDICTIONARY?
    
    let requestHeaders: [String: Any]
    
    public init (baseURLString: String , method : HTTPMethod , path : String , bodyParams : JSONDICTIONARY? = nil , queryParams : JSONDICTIONARY? = nil, requestHeaders: [String: Any]? = nil) {
        
        self.baseURLString = baseURLString
        self.method = method
        self.path = path
        self.bodyParams = bodyParams
        self.queryParams = queryParams
        self.requestHeaders = requestHeaders ?? [:]
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        let urlString = baseURLString + path
        
        var urlComponent = URLComponents(string: urlString)!
        
        if let queryParams = queryParams {
            urlComponent.queryItems = []
            for (key , value) in queryParams {
                if let valueString = value as? String {
                    urlComponent.queryItems?.append(URLQueryItem(name: key, value: valueString))
                }else if let valueArr = value as? Array<String> {
                    for valueStr in valueArr {
                        urlComponent.queryItems?.append(URLQueryItem(name: key, value: valueStr))
                    }
                }
                else {
                    print("queryParameters value (\(value)) is not a string")
                    urlComponent.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
                }
            }
            urlComponent.percentEncodedQuery = urlComponent.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        
        var urlRequest = URLRequest(url: urlComponent.url!)
        
        urlRequest.httpMethod = method.rawValue
        
        //Adjust Body JSON Dictionary
        if let bodyParameters = bodyParams {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters)
        }

        //Adjust Request Headers
        for (key,value) in requestHeaders {
            urlRequest.setValue(value as? String, forHTTPHeaderField: key)
        }
        
        return urlRequest
        
    }
    
}
