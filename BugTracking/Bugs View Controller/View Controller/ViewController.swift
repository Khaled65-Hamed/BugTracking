//
//  ViewController.swift
//  BugTracking
//
//  Created by Khaled Hamed on 07/09/2024.
//

import UIKit
import WXImageCompress
import Firebase

class ViewController: UIViewController {

    @IBOutlet private weak var catchBugButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource : [BugDetails] = []
    let bugDescriptionCellID = "BugDescriptionTableViewCell"
    
    var photosFileUploadManager : PhotosFileUploaderManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureUI()
        self.configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkForSharingExtensionSavings()
    }
    
    private func configureUI() {
        self.navigationItem.title = "Bugs"
        self.catchBugButton.backgroundColor = UIColor.red
        self.catchBugButton.layer.cornerRadius = 8
        self.catchBugButton.clipsToBounds = true
        self.catchBugButton.setTitleColor(.white, for: .normal)
        self.catchBugButton.addTarget(self, action: #selector(catchBugButtonPressed), for: .touchUpInside)
    }


    @objc func catchBugButtonPressed() {
        
        self.photosFileUploadManager =  PhotosFileUploaderManager(presentViewController: { [weak self] currentVC in
            DispatchQueue.main.async {[weak self] in
                self?.present(currentVC, animated: true)
            }
        }, onImageChoosed: { [weak self] image in
            self?.didSetImages(image: image)
        })
        
        self.photosFileUploadManager?.showPhotoOption(title: "Select Bug", sourceView: self.view)
    }
    
    private func checkForSharingExtensionSavings() {
        if let savedBugDetails = UserDefaultsManager.shared.getSharedBugDetails() {
            self.dataSource.append(contentsOf: savedBugDetails)
            self.tableView.reloadData()
        }
    }
    
    func didSetImages(image: UIImage) {
        //we need to save photos to core data
        let imageData = image.wxCompress().jpegData(compressionQuality: 1.0)!
        let prescriptionNotesViewModel = NewArch_PrescriptionNotesViewModel(apiGate: NewArch_ContentUploaderApiGate(), prescriptionImage: image, imageData : imageData , isViewOnly: false, didSubmitImage: nil)
        prescriptionNotesViewModel.didSubmitImage = { (imageNote , imageData , _) in
           
        }
        
        prescriptionNotesViewModel.didAddImageAndReady = { (imageNote , imageData , fileURL) in
            // we need to upload this image to server
            let randomID = UUID.init().uuidString
            let uploadRef = Storage.storage().reference(withPath: "memes\(randomID).jpg")
            let uploadMetaData = StorageMetadata.init()
            uploadMetaData.contentType = "image/jpeg"
            uploadRef.putData(imageData, metadata: uploadMetaData) { downloadMetaData, error in
                if let error = error {
                    print("something went wrong \(error.localizedDescription)")
                    return
                }
                print("the meta data is \(String(describing: downloadMetaData))")
                
                uploadRef.downloadURL { imageURL, error in
                    if let error = error {
                        print("something went wrong \(error.localizedDescription)")
                        return
                    }
                    let imageURL = String(describing: imageURL)
                    print("image url is \(imageURL)")
                    let bugDetails = BugDetails(image: imageData, imageURL: imageURL, bugNotes: imageNote)
                    self.dataSource.append(bugDetails)
                    UserDefaultsManager.shared.saveSharingBugDetails(bugDetails: bugDetails)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }
        }
        let prescriptionNotesViewController = PrescriptionNotesViewController(viewModel: prescriptionNotesViewModel)
        self.navigationController?.present(prescriptionNotesViewController, animated: true)
    }
    
    @IBAction func uploadToGoogleSheet(_ sender: Any?) {
        GoogleSheetManager.shared.addDataToSpreedSheet()
    }
    
}

