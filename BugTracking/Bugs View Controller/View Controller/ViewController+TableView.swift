//
//  ViewController+TableView.swift
//  BugTracking
//
//  Created by Khaled Hamed on 08/09/2024.
//

import Foundation
import UIKit

extension ViewController : UITableViewDataSource , UITableViewDelegate {
    
    func configureTableView() {
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: bugDescriptionCellID, bundle: nil), forCellReuseIdentifier: bugDescriptionCellID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: bugDescriptionCellID, for: indexPath) as? BugDescriptionTableViewCell {
            let bugDetails = self.dataSource[indexPath.row]
            let cellModel = BugDescriptionTableViewCellModel(budDetails: bugDetails)
            cell.bindData(model: cellModel)
            return cell
        }
        return UITableViewCell()
    }
    
    

    
}
