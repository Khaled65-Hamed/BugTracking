//
//  NewArch_FileUploaderRouter.swift
//  Vezeeta
//
//  Created by Sergio Garre on 13/12/2020.
//  Copyright © 2020 Vezeeta. All rights reserved.
//


final class NewArch_FileUploaderRouter: BaseAPIRouter {
    
    //MARK:- Initialization
     init(method: HTTPMethod,
         path: String,
         queryParameters: JSONDICTIONARY? = nil,
         bodyParameters: JSONDICTIONARY? = nil,
         isMultiPart: Bool = false) {
        let baseURL: String = BaseUrl
        
        super.init(baseURLString: baseURL,
                   method: method,
                   path: path,
                   bodyParams: queryParameters,
                   queryParams: bodyParameters)
    }
}
