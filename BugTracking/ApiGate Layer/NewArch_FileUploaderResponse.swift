//
//  NewArch_FileUploaderResponse.swift
//  Vezeeta
//
//  Created by Abdallah Eid on 12/19/20.
//  Copyright © 2020 Vezeeta. All rights reserved.
//

import Foundation

public struct NewArch_FileUploaderResponse: Codable {
    let message: String
    let statusCode: Int
    public let data: [FileUploaderDataResponse]
}

public struct FileUploaderDataResponse: Codable{
    public let fileUrl: String
    public let isUploaded: Bool
    public let fileName: String
}
