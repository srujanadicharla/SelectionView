//
//  SelectionViewDataSource.swift
//  SASelectionView
//
//  Created by Srujan Simha Adicharla on 7/29/20.
//  Copyright © 2020 Srujan Simha Adicharla. All rights reserved.
//

import UIKit


extension SASelectionView: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        if isSearchActive {
            if searchFilterData.count == 0 && emptySearchRowTitle != nil {
                return 1
            } else {
                return searchFilterData.count
            }
        }
        
        return filterData.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive {
            if ((searchFilterData.count > 0 && searchFilterData[section].options.count == 0) || searchFilterData.count == 0) && emptySearchRowTitle != nil {
                return 1
            }
            return searchFilterData[section].options.count
        }
        
        return filterData[section].options.count
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = isSearchActive ? (searchFilterData.count == 0 ? "" : searchFilterData[section].title) : filterData[section].title
        if let sectionHeader: SingleSelectionSectionHeaderView = SingleSelectionSectionHeaderView.loadView() {
            sectionHeader.titleLabel.text = title
            sectionHeader.titleLabel.font = .boldSystemFont(ofSize: 13)
            return sectionHeader
        }
        
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = isSearchActive ? (searchFilterData.count == 0 ? nil : searchFilterData[section].title) : filterData[section].title {
            return UITableView.automaticDimension
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectionViewCell = tableView.dequeReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .default
        cell.titleLabel.textColor = .darkText
        
        if isSearchActive {
            if searchFilterData.count == 0, let emptySearchRowTitle = self.emptySearchRowTitle {
                cell.titleLabel?.text = emptySearchRowTitle
            } else if searchFilterData.count != 0 {
                cell.titleLabel?.text = searchFilterData[indexPath.section].options[indexPath.row]
                if searchFilterData[indexPath.section].disabledIndices[indexPath.section]?.contains(indexPath.row) == true {
                    cell.titleLabel.textColor = UIColor.lightGray.withAlphaComponent(0.54)
                    cell.selectionStyle = .none
                }
            }
        } else {
            cell.titleLabel?.text = filterData[indexPath.section].options[indexPath.row]
            if filterData[indexPath.section].disabledIndices[indexPath.section]?.contains(indexPath.row) == true {
                cell.titleLabel.textColor = UIColor.lightGray.withAlphaComponent(0.54)
                cell.selectionStyle = .none
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearchActive {
            if searchFilterData.count == 0, emptySearchRowTitle != nil {
                emptyRowHandler?(searchTextField.text ?? "")
            } else if searchFilterData.count != 0 {
                let filteredSection = searchFilterData[indexPath.section]
                
                if filteredSection.disabledIndices[indexPath.section]?.contains(indexPath.row) == true {
                    return
                }
                
                for i in 0..<filterData[filteredSection.index].options.count {
                    if filterData[filteredSection.index].options[i] == filteredSection.options[indexPath.row] {
                        selectedOption(filteredSection.index, i, filteredSection.options[indexPath.row])
                        break
                    }
                }
            }
        } else {
            if filterData[indexPath.section].disabledIndices[indexPath.section]?.contains(indexPath.row) == true {
                return
            }
            
            selectedOption(indexPath.section, indexPath.row, filterData[indexPath.section].options[indexPath.row])
        }
        dismissView()
    }
}
