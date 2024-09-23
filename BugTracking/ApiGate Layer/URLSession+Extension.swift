//
//  URLSession+Extension.swift
//  RickAndMorty
//
//  Created by Khaled Hamed on 27/01/2024.
//

import Foundation

extension URLSession {
    func dataTask(with url: URLRequest, result: @escaping BaseAPIHandler.DataHandler) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                var networkError = (error as? BaseNetworkError) ?? BaseNetworkError()
                if let data = data {
                    networkError.data = data
                }
                return result(.failure(networkError))
            }
            guard let response = response, let data = data else {
                let error = BaseNetworkError()
                return result(.failure(error))
            }
            result(.success((response, data)))
        }
    }
}
