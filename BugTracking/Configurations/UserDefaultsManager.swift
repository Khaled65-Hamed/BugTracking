//
//  UserDefaultsManager.swift
//  BugTracking
//
//  Created by Khaled Hamed on 11/09/2024.
//

import Foundation

final class UserDefaultsManager : NSObject {
    let kSharingExtensionBugDetails = "KSharingExtensionBug"
    
    private var userDefaults : UserDefaults {
        get {return UserDefaults.standard}
    }
    
    private var sharingExtensionUserDefaults : UserDefaults {
        get {return UserDefaults(suiteName: "group.BugTrackingShareExtension99") ?? UserDefaults.standard}
    }
    static let shared = UserDefaultsManager()
    
    private override init() {}
    
    @objc func saveSharingBugDetails(bugDetails: BugDetails) {
        var modifiedArr : [BugDetails] = []
        if let oldArray = self.getSharedBugDetails(){
            modifiedArr.append(contentsOf: oldArray)
        }
        modifiedArr.append(bugDetails)
        let bugModelData = BugDetailsData(bugModels: modifiedArr)
        if let encodedData =  try? NSKeyedArchiver.archivedData(withRootObject: bugModelData, requiringSecureCoding: false) {
            sharingExtensionUserDefaults.set(encodedData, forKey: kSharingExtensionBugDetails)
            sharingExtensionUserDefaults.synchronize()
        }
    }
    
    func overrideSavedDetails(bugDetails: [BugDetails]) {
        if let encodedData =  try? NSKeyedArchiver.archivedData(withRootObject: bugDetails, requiringSecureCoding: false) {
            sharingExtensionUserDefaults.set(encodedData, forKey: kSharingExtensionBugDetails)
            sharingExtensionUserDefaults.synchronize()
        }
    }
    
    func getSharedBugDetails()-> [BugDetails]? {
        if let decoded  = sharingExtensionUserDefaults.data(forKey: kSharingExtensionBugDetails) {
            do {
                NSKeyedUnarchiver.setClass(BugDetailsData.self, forClassName: "BugTrackingShareExtension.BugDetailsData")
                NSKeyedUnarchiver.setClass(BugDetails.self, forClassName: "BugTrackingShareExtension.BugDetails")
                let decodedModel = try NSKeyedUnarchiver.unarchivedObject(ofClass: BugDetailsData.self, from: decoded)
                return decodedModel?.bugModels
            }
            catch(let error) {
                print("error is \(error)")
            }
            
            
        }
        return nil
    }
}
