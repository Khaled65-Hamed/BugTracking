//
//  BaseNetwrokError.swift
//  RickAndMorty
//
//  Created by Khaled Hamed on 27/01/2024.
//

import Foundation

public enum BaseAPIErrorType {
    case apiError
    case invalidURL
    case invalidResponse
    case noData
    case decodeError
    case noInternet
    case custom
}

public struct BaseNetworkError: Error {
    
    public var type: BaseAPIErrorType
    public var statusCode: Int?
    public var data: Data?
    public var customError: String?
    public var customErrorTitle: String?

    public init(type: BaseAPIErrorType = .custom,
         customError: String? = nil,
         customErrorTitle: String? = nil,
         statusCode: Int? = nil,
         data: Data? = nil) {
        self.type = type
        self.statusCode = statusCode
        self.data = data
        self.customError = customError
        self.customErrorTitle = customErrorTitle
    }
}
