//  File: SNTableViewDiffableDataSource.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 9/30/25.

import UIKit

protocol SNTableViewDiffableDataSourceDelegate
{
    var courseProjects: [CourseProject] { get set }
    var completedProjects: [CourseProject] { get set }
    func updateCompletedBin(with: CourseProject, actionType: ProjectPersistenceActionType)
}

/** this subclass is here only to make the 'commit editingStyle' override method work */
class SNTableViewDiffableDataSource: UITableViewDiffableDataSource<Section, CourseProject.ID>
{
    var delegate: SNTableViewDiffableDataSourceDelegate!
    
    
    init(delegate: SNTableViewDiffableDataSourceDelegate!)
    {
        self.delegate = delegate
    }
    
    //-------------------------------------//
    // MARK: - TABLEVIEW DELEGATE METHODS 2/2

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    { return true }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let currentProject = delegate.courseProjects[indexPath.row]
        if editingStyle == .insert {
            delegate.updateCompletedBin(with: currentProject, actionType: .complete)
            tableView.cellForRow(at: indexPath)?.editingAccessoryType = .checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            index(project: currentProject)
        }
        else {
            delegate.updateCompletedBin(with: currentProject, actionType: .incomplete)
            tableView.cellForRow(at: indexPath)?.editingAccessoryType = .none
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            deindex(item: currentProject)
        }
    }
    
    //-------------------------------------//
    // MARK: - INDEXING (ENABLES SPOTLIGHT SEARCHING)
    
    func index(project: CourseProject)
    {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: UTType.text.description as String)
        attributeSet.title = project.title
        attributeSet.contentDescription = project.subtitle
        
        let item = CSSearchableItem(uniqueIdentifier: "\(project.index)",
                                    domainIdentifier: "com.hackingwithswift",
                                    attributeSet: attributeSet)
        item.expirationDate = Date.distantFuture
        
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error { print("Indexing error: \(error)") }
            else { print("Search item successfully indexed!") }
        }
    }
    
    
    func deindex(item: CourseProject)
    {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item.index)"]) { error in
            if let error = error { print("Deindexing error: \(error)") }
            else { print("Search item successfully removed!") }
        }
    }
}
