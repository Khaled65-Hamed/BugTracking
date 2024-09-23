//
//  NewArch_ContentUploaderApiGate.swift
//  APIGate
//
//  Created by Khaled Hamed on 12/11/2023.
//

import Foundation

public typealias OnSuccessContentUploaderResult = (_ fileURL : String) -> Void
public typealias OnFailureOperation = (BaseNetworkError) -> Void

public class NewArch_ContentUploaderApiGate : BaseAPIHandler{
    
    private enum EndPoint : String {
        case UploadContent = "contentuploader"
    }
    
    private enum Attributes : String {
        
        case OperationKey = "OperationKey"
        case ServiceKey = "ServiceKey"
    }
    
    public func uploadContent(imageData: Data , userKey : String , OnSuccess: @escaping OnSuccessContentUploaderResult, OnFailure: @escaping OnFailureOperation) {
        
        let bodyParameters = [
            Attributes.OperationKey.rawValue: userKey as AnyObject
        ]
        
        let router = NewArch_FileUploaderRouter(method: .post,
                                        path: EndPoint.UploadContent.rawValue,
                                        bodyParameters: bodyParameters,
                                        isMultiPart: true)
        
        
        super.performNetworkRequest(forRouter: router, jsonDecoder: JSONDecoder()) { (result: Result<NewArch_FileUploaderResponse, BaseNetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        if let fileUrl = response.data.first?.fileUrl {
                            OnSuccess(fileUrl)
                        }
                    }
                case .failure(let apiError):
                    DispatchQueue.main.async {
                        OnFailure(apiError)
                    }
                }
            }
        }
    }
    
}
