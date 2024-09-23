//
//  VZTextFieldWithLabeled.swift
//  Vezeeta
//
//  Created by Ahmed Ezz on 11/01/2022.
//  Copyright © 2022 Vezeeta. All rights reserved.
//

import UIKit

class VZTextFieldWithLabeled: UIView {

    //MARK: - ConstantsUI
    private let containerViewHeight: CGFloat = 56
    private let defaultBorderWidth: CGFloat = 1
    private let defaultCornerRadious: CGFloat = 8
    let errorLabelBottom: CGFloat = 4
    let textFieldTrailing: CGFloat = -16
    let textFieldLeading: CGFloat = 16
    private let textFieldHeight: CGFloat = 24
    private let defautltBorderColor = UIColor.gray
    private let defaultActiveBorderColor = UIColor.blue
    private let defaultErrorBorderColor = UIColor.red
    
    //MARK: - Variables
    private enum PlaceHolderTopConstant: CGFloat {
        case top = 7
        case bottom = 20
    }
    
    private enum TextFieldBottomConstant: CGFloat {
        case center = -16
        case bottom = -7
    }
    
    var textField: UITextField!
    private var placeHolderLabel: UILabel!
    private var errorLabel: UILabel!
    private var stackView: UIStackView!
    private var errorContainerView: UIView!
    private var placeHolderTopConstraints: NSLayoutConstraint!
    private lazy var hasError: Bool = false
    private lazy var validationRegex: String = ""
    private lazy var isBeginEditing = false
    private lazy var placeHolderAttributed: NSMutableAttributedString? = nil
    private var textFieldTrailingConstraints: NSLayoutConstraint!
    private var textFieldLeadingConstraints: NSLayoutConstraint!
    private var errorContainerViewHeightConstraint: NSLayoutConstraint!
    var textFieldBottomConstraints: NSLayoutConstraint!
    private var placeHolderLeadingConstraints: NSLayoutConstraint!

    var containerView: UIView!
        
    lazy var textAlignment: NSTextAlignment? = nil {
        didSet{
            self.placeHolderLabel.textAlignment = textAlignment ?? .left
            self.textField.textAlignment = textAlignment ?? .left
        }
    }
    
    lazy var removeDoneKeyboard: Bool? = nil {
        didSet{
            self.textField.inputAccessoryView = nil
        }
    }
    
    lazy var textFieldInputView: UIView? = nil {
        didSet {
            self.textField.inputView = textFieldInputView
        }
    }
    
    lazy var textFieldInputAccessoryView: UIView? = nil {
        didSet {
            self.textField.inputAccessoryView = textFieldInputAccessoryView
        }
    }
    
    lazy var enableSecurity: Bool = false {
        didSet {
            self.textField.isSecureTextEntry = enableSecurity
        }
    }
    
    lazy var didViewClicked:(()->())? = nil
    
    lazy var disbaleTextEdit: Bool = false {
        didSet {
            self.textField.isUserInteractionEnabled = disbaleTextEdit == false
        }
    }
    
    lazy var disbaleTextEditWithoutInput: Bool = false
    
    lazy var errorMessage: String? = nil {
        didSet {
            self.errorLabel.text = errorMessage ?? ""
        }
    }
    
    var returnKeyType: UIReturnKeyType {
        get {
            textField.returnKeyType
        }
        
        set {
            textField.returnKeyType = newValue
        }
    }
    
    //MARK:- Keyboard Handle
    func showKeyboard() {
        textField.becomeFirstResponder()
    }
    
    func dismissKeyboard() {
        textField.resignFirstResponder()
    }
    
    @IBInspectable lazy var hasValidation: Bool = true
    
    weak var delegate: VZTextFieldLabeledDelegate?
    weak var textFieldDelegate: UITextFieldDelegate? = nil
    
    var maxLength: Int? = nil
    
    lazy var keyboardType: UIKeyboardType =  .default {
        didSet {
            self.textField.keyboardType  = keyboardType
        }
    }
    
    @IBInspectable lazy var hasTitleLabel: Bool = true {
        didSet {
            self.movePlaceHolder()
        }
    }
    
    @IBInspectable lazy var text: String? = "" {
        didSet {
            self.textField.text = text
            if let _ = text {
                self.movePlaceHolder()
                self.moveTextField()
            }
        }
    }
    
    @IBInspectable lazy var placeHolderText:String? = nil {
        didSet {
            self.changePlaceHolderAttribute()
        }
    }
    
    @IBInspectable lazy var placeHolderColor: UIColor = UIColor.gray {
        didSet {
            self.changePlaceHolderAttribute()
        }
    }
    
    lazy var requiredStarTextColor: UIColor = placeHolderColor {
        didSet {
            self.changePlaceHolderAttribute()
        }
    }
    
    lazy var placeHolderFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            self.changePlaceHolderAttribute()
        }
    }
    
    @IBInspectable lazy var errorColor: UIColor = .red {
        didSet {
            errorLabel.textColor = errorColor
        }
    }
    
    lazy var errorFont: UIFont = .systemFont(ofSize: 12) {
        didSet {
            errorLabel.font = errorFont
        }
    }
    
    lazy var textFont: UIFont = .systemFont(ofSize: 16) {
        didSet {
            self.textField.font = textFont
        }
    }
    
    @IBInspectable lazy var textColor: UIColor = .black {
        didSet {
            self.textField.textColor = textColor
        }
    }
    
    //MARK: - Initilaize
    override init(frame: CGRect) {
        super.init(frame: .infinite)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    private func initViews() {
        self.configureContainerView()
        self.configureTextField()
        self.configurePlaceHolder()
        self.configureErrorLabel()
        self.addStackView()
    }
    
    private func addClick() {
        self.containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewClicked)))
    }
    
    @objc private func onViewClicked() {
        self.textField.becomeFirstResponder()
        didViewClicked?()
    }
    
    //MARK: - configureViews
    private func configureContainerView() {
        self.containerView = UIView()
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([self.containerView.heightAnchor.constraint(equalToConstant: containerViewHeight)])
        self.addDefaultBorder()
        self.addClick()
    }
    
    private func configureErrorLabel() {
        self.errorContainerView = UIView()
        self.errorLabel = UILabel()
        self.errorContainerView.addSubview(errorLabel)
        self.errorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.errorLabel.font = errorFont
        self.errorLabel.textColor = errorColor
        self.errorLabel.text = errorMessage
        NSLayoutConstraint.activate([self.errorLabel.leadingAnchor.constraint(equalTo: self.errorContainerView.leadingAnchor,constant: 0),self.errorLabel.trailingAnchor.constraint(equalTo: self.errorContainerView.trailingAnchor,constant: 0),self.errorLabel.topAnchor.constraint(equalTo: self.errorContainerView.topAnchor,constant: errorLabelBottom),errorLabel.bottomAnchor.constraint(equalTo: errorContainerView.bottomAnchor,constant: errorLabelBottom * -1 )])
    }
    
    private func addStackView() {
        stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(errorContainerView)
        self.addSubview(stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),self.stackView.topAnchor.constraint(equalTo: self.topAnchor),self.stackView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        self.errorContainerView.isHidden = true
    }
    
    private func configureTextField() {
        self.textField = UITextField()
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.delegate = self
        self.textField.addDoneButtonOnKeyboard()
        self.containerView.addSubview(textField)
        textFieldTrailingConstraints = NSLayoutConstraint(item: self.textField ?? UITextField(), attribute: .trailing, relatedBy: .equal, toItem: self.containerView, attribute: .trailing, multiplier: 1, constant: textFieldTrailing)
        textFieldLeadingConstraints = NSLayoutConstraint(item: self.textField ?? UITextField(), attribute: .leading, relatedBy: .equal, toItem: self.containerView, attribute: .leading, multiplier: 1, constant: textFieldLeading)
        textFieldBottomConstraints = NSLayoutConstraint(item: self.textField ?? UITextField(), attribute: .bottom, relatedBy: .equal, toItem: self.containerView, attribute: .bottom, multiplier: 1, constant: getTextFieldBottomConstraint())
        NSLayoutConstraint.activate([textFieldLeadingConstraints,textFieldTrailingConstraints,self.textField.heightAnchor.constraint(equalToConstant: textFieldHeight),textFieldBottomConstraints])
        textField.textColor = textColor
        textField.font = textFont
        textField.inputView = textFieldInputView
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func configurePlaceHolder() {
        placeHolderLabel = UILabel()
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(placeHolderLabel)
        placeHolderTopConstraints = NSLayoutConstraint(item: self.placeHolderLabel ?? UILabel(), attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1, constant: getPlaceHolderTopConstraint())
        placeHolderLeadingConstraints = NSLayoutConstraint(item: self.placeHolderLabel ?? UILabel(), attribute: .leading, relatedBy: .equal, toItem: self.containerView, attribute: .leading, multiplier: 1, constant: textFieldLeading)
        
        NSLayoutConstraint.activate([placeHolderLeadingConstraints,self.placeHolderLabel.trailingAnchor.constraint(equalTo: self.textField.trailingAnchor),placeHolderTopConstraints])
        placeHolderLabel.textColor = placeHolderColor
        placeHolderLabel.font = placeHolderFont
    }
    
    //MARK: - HelperFunctiosn
    private func movePlaceHolder() {
        self.placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        let placeHolderTopConstraintConstant = getPlaceHolderTopConstraint()
        self.placeHolderLabel.isHidden = placeHolderTopConstraintConstant == PlaceHolderTopConstant.top.rawValue && hasTitleLabel == false
        self.placeHolderTopConstraints.constant = getPlaceHolderTopConstraint()
    }
    
    private func moveTextField() {
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldBottomConstraints.constant = getTextFieldBottomConstraint()
    }
    
    private func getPlaceHolderTopConstraint()-> CGFloat {
        let topConstaintConstant = self.text?.isEmpty == true ? PlaceHolderTopConstant.bottom.rawValue : PlaceHolderTopConstant.top.rawValue
        return topConstaintConstant
    }
    
    private func getTextFieldBottomConstraint()-> CGFloat {
        let topConstaintConstant = self.text?.isEmpty == true ? TextFieldBottomConstant.center.rawValue : TextFieldBottomConstant.bottom.rawValue
        return topConstaintConstant
    }
    
    func updateTextFieldtrailing(with constant:CGFloat) {
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldTrailingConstraints.constant = constant
    }
    
    func updateTextFieldLeading(with constant:CGFloat) {
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldLeadingConstraints.constant = constant
    }
    
    func updatePlaceHolderLeading(with constant:CGFloat) {
        self.placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        self.placeHolderLeadingConstraints.constant = constant
    }
    
    private func updateTextFieldBottom(with constant:CGFloat) {
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldBottomConstraints.constant = constant
    }
    
    private func changePlaceHolderAttribute() {
        self.placeHolderAttributed = NSMutableAttributedString(string: placeHolderText ?? "",attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor,NSAttributedString.Key.font: placeHolderFont])
        guard let textRange = (placeHolderText as NSString?)?.range(of: "*") else {
            return
        }
        self.placeHolderAttributed?.addAttribute(NSAttributedString.Key.foregroundColor, value: requiredStarTextColor, range: textRange)
        self.placeHolderLabel.attributedText = placeHolderAttributed
    }
    
    //MARK: - textChanges
    @objc func textFieldDidChange () {
        self.text = "\(self.textField.text ?? "" )"
        self.delegate?.onTextChanged?(textField: self, text: text ?? "")
        self.movePlaceHolder()
        self.moveTextField()
        if hasValidation {
            self.checkValidation()
        }
    }
    
    //MARK: - validation Methods
    func setError() {
        self.hasError = true
        self.delegate?.onDataError?(textField: self)
        if hasValidation == true {
            if text?.isEmpty == true && placeHolderText?.contains("*") == false {
                self.errorLabel.isHidden = true
                self.errorContainerView.isHidden = true
                self.containerView.addCornerRadius(raduis: self.containerView.layer.cornerRadius, borderColor: defaultActiveBorderColor, borderWidth: defaultBorderWidth)
            } else {
                self.errorLabel.isHidden = false
                self.errorContainerView.isHidden = false
                self.containerView.addCornerRadius(raduis: self.containerView.layer.cornerRadius, borderColor: defaultErrorBorderColor, borderWidth: defaultBorderWidth)
                if text?.isEmpty == true || text == nil {
                    var emptyTextError = placeHolderText
                    emptyTextError = emptyTextError?.replacingOccurrences(of: "*", with: "")
                    self.errorLabel.text = "\(emptyTextError ?? "") \("is required")"
                } else {
                    self.errorLabel.text = errorMessage
                }
            }
        } else {
            self.errorLabel.isHidden = false
            self.errorContainerView.isHidden = true
            self.containerView.addCornerRadius(raduis: self.containerView.layer.cornerRadius, borderColor: defaultErrorBorderColor, borderWidth: defaultBorderWidth)
        }
    }
    
    func removeError() {
        self.hasError = false
        self.delegate?.onDataValid?(textField: self)
        self.changePlaceHolderAttribute()
        let _ = isBeginEditing ?
            self.containerView.addCornerRadius(raduis: self.containerView.layer.cornerRadius, borderColor: defaultActiveBorderColor, borderWidth: defaultBorderWidth) : self.addDefaultBorder()
        self.errorLabel.isHidden = true
        self.errorContainerView.isHidden = true
    }
    
    func setValidation(validationRegex: String,errorMessage: String? = nil ) {
        self.validationRegex = validationRegex
        self.errorMessage = errorMessage
        self.errorLabel.text = errorMessage
    }
    
    private func checkValidation() {
        let textTest = NSPredicate(format:"SELF MATCHES %@", validationRegex)
        let _ = textTest.evaluate(with: self.text) ? removeError() : setError()
    }
    
    func textHasError() -> Bool {
        if hasValidation {
            self.checkValidation()
        }
        return hasError
    }
    
    private func handleInputView(isBeginEditing: Bool) {
        if isBeginEditing {
            self.textField.isHidden = disbaleTextEditWithoutInput
        } else {
            self.textField.isHidden = false
        }
    }
    
    private func canAddDefaultBorder() {
        if errorLabel.isHidden {
            self.addDefaultBorder()
        }
    }
    
    func addDefaultBorder() {
        self.containerView.addCornerRadius(raduis: defaultCornerRadious, borderColor: defautltBorderColor, borderWidth: defaultBorderWidth)
    }
    
    func makeFirstResponder() {
        self.textField.becomeFirstResponder()
    }

}

//MARK: - TextFieldDelegate Methods
extension VZTextFieldWithLabeled: VZTextFieldLabeledDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing?(textField)
        self.handleInputView(isBeginEditing: false)
        self.canAddDefaultBorder()
        self.isBeginEditing = false
        self.delegate?.textFieldDidEndEditing?(textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.handleInputView(isBeginEditing: true)
        self.isBeginEditing = true
        delegate?.textFieldDidBeginEditing?(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let _ = delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string)
        if let maxLength = maxLength {
            let currentString = textField.text! as NSString
            let newString =  currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
        }
        return true
    }
}

//MARK: - TextFieldLabeledDelegate
@objc protocol VZTextFieldLabeledDelegate: UITextFieldDelegate {
    @objc optional func onTextChanged(textField: VZTextFieldWithLabeled, text: String)
    @objc optional func onDataValid(textField: VZTextFieldWithLabeled)
    @objc optional func onDataError(textField: VZTextFieldWithLabeled)
}

extension UITextField {
   func addDoneButtonOnKeyboard() {
       let keyboardToolbar = UIToolbar()
       keyboardToolbar.sizeToFit()
       let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
           target: nil, action: nil)
       let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
           target: self, action: #selector(resignFirstResponder))
       keyboardToolbar.items = [flexibleSpace, doneButton]
       self.inputAccessoryView = keyboardToolbar
   }
}

extension UIView {
    static func isDirectionArabic () -> Bool {
        let appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String]
        return appleLanguages?.first?.contains("ar") == true
    }
}

enum VZValidationRegex: String {
    case Email = "[A-Z0-9a-z_%+-]+[A-Z0-9a-z._%+-]*@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    case Password = "^.{6,}$"
    case Name = "^[A-Za-zء-ي-\\s]{2,150}"
    case Age = "^[0-9٠-٩]{1,2}$"
    case Question = "^.{2,50}$"
    case NormalText = "^.{0,200}$"
}

enum VZValidationErrorMessage: String {
    case Email = "Enter a valid Email"
    case Phone = "Enter a valid phone number"
    case Password = "Password must be at least 6 characters"
    case Name = "Enter a valid Name"
    case Age = "Age Validation"
    case Question = "Question Validation"
    case Birthdate = "BirthDate is Required"
}
