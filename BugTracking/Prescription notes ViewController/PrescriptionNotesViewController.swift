//
//  PrescriptionNotesViewController.swift
//  Vezeeta
//
//  Created by Khaled Hamed on 14/09/2023.
//  Copyright © 2023 Vezeeta. All rights reserved.
//

import Foundation
import UIKit

class PrescriptionNotesViewController: UIViewController {

    //MARK:- Private Outlets
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var prescriptionImageView: UIImageView!
    
    @IBOutlet private weak var bottomView: UIView! {
        didSet {
            bottomView.backgroundColor = .white
        }
    }
    
    @IBOutlet private weak var noteTitleLabel: UILabel! {
        didSet {
            noteTitleLabel.font = .systemFont(ofSize: 16)
            noteTitleLabel.textColor = .gray
            noteTitleLabel.text = "Add a note (optional)"
        }
    }
    
    @IBOutlet private weak var notesTextField: VZTextFieldWithLabeled! {
        didSet {
            notesTextField.accessibilityIdentifier = "notesTextField"
            notesTextField.placeHolderText = "Add bug note"
            notesTextField.setValidation(validationRegex: VZValidationRegex.NormalText.rawValue)
            notesTextField.returnKeyType = .send
            if !viewModel.isViewOnly {
                notesTextField.showKeyboard()
            }
        }
    }
    
    @IBOutlet private weak var nextButton: UIButton! {
        didSet {
            nextButton.accessibilityIdentifier = "nextButton"
            nextButton.backgroundColor = .blue
            nextButton.layer.cornerRadius = nextButton.frame.width / 2
            nextButton.tintColor = .white
            nextButton.setImage(UIImage(named: "LabsMarketPlace-Send"), for: .normal)
        }
    }
    
    
    @IBOutlet private weak var closeButton: UIButton! {
        didSet {
            closeButton.accessibilityIdentifier = "closeButton"
            closeButton.tintColor = .white
            closeButton.setImage(UIImage(named: "Dark-Close"), for: .normal)
        }
    }
    
    @IBOutlet private weak var notesViewHeight: NSLayoutConstraint!

    //MARK:- Private Variables
    private var viewModel: NewArch_PrescriptionNotesViewModel!
    
    //MARK:- initialization
    init(viewModel: NewArch_PrescriptionNotesViewModel) {
        super.init(nibName: "\(PrescriptionNotesViewController.self)", bundle: nil)
        self.viewModel = viewModel
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        if viewModel.isViewOnly {
            notesViewHeight.constant = 0
            bottomView.isHidden = true
        }
        
        configureImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:- Configuration
    func configureImages() {
        prescriptionImageView.image = viewModel.prescriptionImage
        backgroundImage.image = viewModel.prescriptionImage
        backgroundImage.layer.add(CATransition(), forKey: "fade")
    }
    
    public func submitImage() {
        var userKey = "Anonymous_iOS+\(UUID().uuidString)"
        viewModel.submitImage(text: notesTextField.text ?? "", imageData: viewModel.imageData, userKey: userKey) { [weak self] _ in
            
        } onFailure: { [weak self] _ in

        }
    }
    
    //MARK:- Actions
    @IBAction func closeAction(_ sender: Any) {
        notesTextField.dismissKeyboard()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        var userKey = "Anonymous_iOS+\(UUID().uuidString)"
        self.viewModel.imageReadyToSubmit(text: notesTextField.text ?? "", imageData: viewModel.imageData, userKey: userKey)
        self.dismiss(animated: true)
    }
    
}
