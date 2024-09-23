//
//  ShareViewController.swift
//  BugTrackingShareExtension
//
//  Created by Khaled Hamed on 11/09/2024.
//

import UIKit
import Social
import CoreServices
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {
    private var appURLString = "BugTrackingShareExtension99://"
    private let typeImage = String("public.image")
    private let typeText = String("public.text")
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        let imageTextNote = contentText ?? ""
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
                    let itemProvider = extensionItem.attachments?.first else {
                        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                        return
                }
        
        if let attachments = extensionItem.attachments {
            for attachment in attachments {
                print("Available types: \(attachment.registeredTypeIdentifiers)")
            }
        }

                // Check if object is of type text
                if itemProvider.hasItemConformingToTypeIdentifier(typeImage) {
                    handleIncomingImage(itemProvider: itemProvider, imageNote: imageTextNote)
                // Check if object is of type URL
                } else {
                    print("Error: No url or text found")
                    self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                }
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    private func handleIncomingImage(itemProvider : NSItemProvider, imageNote : String) {
        itemProvider.loadItem(forTypeIdentifier: typeImage, options: nil) { (item, error) in
            if let error = error {
                print("Text-Error: \(error.localizedDescription)")
            }
            
            if let imageURL = item as? NSURL {
                let urlString: String = imageURL.absoluteString!
                let data = try? Data(contentsOf: URL(string: urlString)!)
                UserDefaultsManager.shared.saveSharingBugDetails(bugDetails: BugDetails(image: data, imageURL: urlString ,bugNotes: imageNote))
                self.openMainApp()
            }
        }
    }
    
    private func openMainApp() {
        
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
            guard let url = URL(string: self.appURLString) else { return }
            let _ = self.openURL(url)
        })
    }
    
    @objc func openURL(_ url: URL) -> Bool {
            var responder: UIResponder? = self
            while responder != nil {
                if let application = responder as? UIApplication {
                    return application.perform(#selector(openURL(_:)), with: url) != nil
                }
                responder = responder?.next
            }
            return false
        }
}
