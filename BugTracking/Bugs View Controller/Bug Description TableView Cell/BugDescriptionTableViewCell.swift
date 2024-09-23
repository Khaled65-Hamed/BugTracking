//
//  BugDescriptionTableViewCell.swift
//  BugTracking
//
//  Created by Khaled Hamed on 08/09/2024.
//

import Foundation
import UIKit

class BugDescriptionTableViewCell : UITableViewCell {
    
    @IBOutlet private weak var bugImageView: UIImageView!
    @IBOutlet private weak var bugDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func bindData(model : BugDescriptionTableViewCellModel?) {
        guard let model = model else {return}
        var documentsUrl: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        
        if let data = model.budDetails.image {
            self.bugImageView.image = UIImage(data: data)
        }
        
        else if let filePath = model.budDetails.imageURL {
            let url = documentsUrl.appendingPathComponent(filePath)
            do {
                if let data = try? Data(contentsOf: URL(string: filePath)!){
                    self.bugImageView.image = UIImage(data: data)
                }
            }
        }
       
        self.bugDescriptionLabel.text = model.budDetails.bugNotes
        
    }
}
