//
//  PrescriptionNotesViewModel.swift
//  Vezeeta
//
//  Created by Khaled Hamed on 14/09/2023.
//  Copyright © 2023 Vezeeta. All rights reserved.
//

import Foundation
import UIKit

public class NewArch_PrescriptionNotesViewModel {
    
    public var prescriptionImage: UIImage
    
    public var isViewOnly: Bool
    
    public var didSubmitImage: ((String, Data , String) -> Void)?
    
    public var didAddImageAndReady: ((String, Data , String) -> Void)?
    
    public var imageData: Data
    var apiGate : NewArch_ContentUploaderApiGate
    
    //MARK:- initialization
    public init(apiGate : NewArch_ContentUploaderApiGate ,prescriptionImage: UIImage, imageData : Data , isViewOnly: Bool, didSubmitImage: ((String, Data , String) -> Void)?) {
        self.apiGate = apiGate
        self.prescriptionImage = prescriptionImage
        self.imageData = imageData
        self.isViewOnly = isViewOnly
        self.didSubmitImage = didSubmitImage
    }
    
    public func submitImage(text: String, imageData: Data , userKey: String , onSuccess : @escaping ((_ fileURL : String) -> Void) , onFailure : @escaping ((BaseNetworkError) -> Void)) {
        
        self.apiGate.uploadContent(imageData: imageData, userKey: userKey) { [weak self] UploadedFileURL in
            onSuccess(UploadedFileURL)
            self?.didSubmitImage?(text, imageData , UploadedFileURL)
        } OnFailure: { error in
            onFailure(error)
        }
    }
    
    public func imageReadyToSubmit(text: String, imageData: Data , userKey: String) {
        self.didAddImageAndReady?(text, imageData, userKey)
    }
}
