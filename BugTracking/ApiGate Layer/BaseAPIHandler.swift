//
//  BaseAPIHandler.swift
//  RickAndMorty
//
//  Created by Khaled Hamed on 27/01/2024.
//

import Foundation

open class BaseAPIHandler : NSObject {
    
    typealias DataHandler = (Result<(URLResponse,Data) , BaseNetworkError>) -> Void
    
    private func performRequest(forRouter router : BaseAPIRouter , then handler : @escaping DataHandler) {
        
        if !NetworkMonitor.shared.isConnected {
            handler(.failure(BaseNetworkError(type: .noInternet)))
        }else {
            do {
                let request = try router.asURLRequest()
                URLSession.shared.dataTask(with: request, result: handler).resume()
            }catch {
                handler(.failure(BaseNetworkError(type: .invalidURL)))
            }
        }
        
    }
    
    public func performNetworkRequest<T: Decodable>(forRouter router: BaseAPIRouter, jsonDecoder: JSONDecoder, then handler : @escaping (Result<T,BaseNetworkError>) -> Void) {
        
        self.performRequest(forRouter: router) { (result) in
            switch result{
            case .success((let response , let data)):
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    guard 200..<299 ~= statusCode else {
                        handler(.failure(BaseNetworkError(type: .invalidResponse , statusCode: statusCode , data: data)))
                        return
                    }
                    do {
                        let values = try jsonDecoder.decode(T.self, from: data)
                        handler(.success(values))
                        
                    } catch {
                        handler(.failure(BaseNetworkError(type: .decodeError)))
                    }
                }else {
                    handler(.failure(BaseNetworkError(type: .invalidResponse)))
                }
                break
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
}
