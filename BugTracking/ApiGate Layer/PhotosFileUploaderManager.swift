//
//  PhotosFileUploaderManager.swift
//  BugTracking
//
//  Created by Khaled Hamed on 07/09/2024.
//

import UIKit
import AVFoundation
import Photos

public class PhotosFileUploaderManager: NSObject {
    
    private var presentViewController:((UIViewController)->())
    private var onImageChoosed:((UIImage)->())
    private lazy var  picker = UIImagePickerController()

    
    init(presentViewController:@escaping ((UIViewController)->()), onImageChoosed:@escaping ((UIImage)->())) {
        self.presentViewController = presentViewController
        self.onImageChoosed = onImageChoosed
    }
    
    public func showPhotoOption(title: String, sourceView: UIView?) {
        let optionMenu = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.photoGalleryAsscessRequest()
        })
        
        let cameraAction = UIAlertAction(title: "Camera" , style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let camerAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
            if camerAuthStatus == .denied {
                self.showCameraPermissionDeniedAlert()
            }
            else {
                self.openCamera()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel" , style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            // Do nothing
        })
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cancelAction)
        
        optionMenu.popoverPresentationController?.sourceView = sourceView ?? UIView()
        optionMenu.popoverPresentationController?.sourceRect = sourceView?.bounds ?? CGRect()
        
        self.presentViewController(optionMenu)
    }
    
    private func openCamera() {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.delegate = self
            self.presentViewController(picker)
        }
        else {
            showGeneralAlert(title: "Camera Not Found", message: "This device has no Camera", alertActions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }
    }
    
    private func photoGalleryAsscessRequest() {
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if result == .authorized {
                    self.openGallery()
                } else {
                    self.showPhotosPermissionDeniedAlert()
                    
                }
            }
        }
    }
    
    private func openGallery() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.presentViewController(picker)
    }
    
    private func showPhotosPermissionDeniedAlert() {
        let cancelAction = UIAlertAction(title: "Cancel" , style: .cancel, handler: nil)
        
        let settingsAction = UIAlertAction(title: "Settings" , style: .default) { (_) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        showGeneralAlert(title: "AppPermissionPhotosDeniedTitle" , message: "AppPermissionPhotosDeniedMessage" , alertActions: [cancelAction, settingsAction])
    }
    
    private func showCameraPermissionDeniedAlert() {
        let cancelAction = UIAlertAction(title: "Cancel" , style: .cancel, handler: {
            _ in
        })
        let settingsAction = UIAlertAction(title: "Settings" , style: .default) { (_) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        showGeneralAlert(title: "AppPermissionCameraDeniedTitle" , message: "AppPermissionCameraDeniedMessage" , alertActions: [cancelAction, settingsAction])
    }
    
    private func showGeneralAlert(title: String, message: String?, alertActions: [UIAlertAction]) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in alertActions {
            alert.addAction(action)
        }
        
        self.presentViewController(alert)
    }
}

//MARK:- UIImagePickerControllerDelegate
extension PhotosFileUploaderManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {
            self.onImageChoosed(image)
        }
        
        if let image = info[.originalImage] as? UIImage {
            self.onImageChoosed(image)
        }
    }
}
