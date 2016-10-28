//
//  ToDoTableViewController.swift
//  ToDoListSKC
//
//  Created by Sean Crowl on 10/24/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    @IBOutlet weak var showIncomplete: UISwitch!
    @IBOutlet weak var addCategoryField: UITextField!
    
    
    var todo = ToDo()
    var todocell = ToDoTableViewCell()
    var todostore = ToDoStore()
    var tododetail = ToDoDetailViewController()
    
    var completeTrue = 0
    var searching = false
    let searchController = UISearchController(searchResultsController: nil)
    var searchResults: [[ToDo]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search ToDo Items"
        self.navigationItem.titleView = searchController.searchBar
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #TODO Incomplete implementation, return the number of sections
        return tododetail.categoryArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searching && searchController.searchBar.text != "" {
            return searchResults[section].count
        }
        return ToDoStore.shared.getCount(categorySet: section)
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ToDoTableViewCell.self)) as! ToDoTableViewCell
        
        if searching && searchController.searchBar.text != "" {
            let todo = searchResults[indexPath.section][indexPath.row]
            cell.setupCell(todo: todo)
        } else {
        cell.setupCell(todo: ToDoStore.shared.getToDo(indexPath.row, categorySet: indexPath.section))
        
        if completeTrue == 1 {
            if cell.isComplete == true {
                cell.isHidden = true
                self.tableView.rowHeight = 0
            } else {
                cell.isHidden = false
                self.tableView.rowHeight = 80
            }
        }
        
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     /*   switch (section) {
        case 0:
            return "Work"
        case 1:
            return "Home"
        default:
            return "Other"
        }  */
        
        if let categoryArray = tododetail.categoryArray as [String]?
        {
            return categoryArray[section]
        }
        
        // This should never happen, but is a fail safe
        return "unknown"
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section == proposedDestinationIndexPath.section {
            return proposedDestinationIndexPath
        } else {
            return sourceIndexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            ToDoStore.shared.deleteToDo(indexPath.row, categorySet: indexPath.section)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDoStore.shared.save()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }



    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditToDoSegue" {
            let toDoDetailVC = segue.destination as! ToDoDetailViewController
            let tableCell = sender as! ToDoTableViewCell
            toDoDetailVC.todo = tableCell.todo
            ToDoStore.shared.save()
        }
}
    
    // MARK: - Unwind Segue
    @IBAction func saveToDoDetail(_ segue: UIStoryboardSegue) {
        let toDoDetailVC = segue.source as! ToDoDetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {

            ToDoStore.shared.deleteToDo(indexPath.row, categorySet: indexPath.section)
            ToDoStore.shared.addToDo(toDoDetailVC.todo, categorySet: toDoDetailVC.todo.categorySet)
            ToDoStore.shared.save()
            tableView.reloadData()
        } else {
            let indexPath = IndexPath(row: 0, section: toDoDetailVC.todo.categorySet)
            ToDoStore.shared.addToDo(toDoDetailVC.todo, categorySet: indexPath.section)
            tableView.insertRows(at: [indexPath], with: .automatic)
            ToDoStore.shared.save()

        
        }
    }
    
    // MARK: - Notification Functions

     
    
    // MARK: - IBActions
    @IBAction func toggleIncomplete(_ sender: AnyObject) {
        if showIncomplete.isOn {
            completeTrue = 1
            self.tableView.reloadData()
        } else {
            completeTrue = 2
            self.tableView.reloadData()
        }
    }
 
    // MARK: - Search Functions
    func searchToDos(searchText: String) -> [[ToDo]] {
        var searchResults: [[ToDo]] = []
        for index in 0..<todostore.todos.count {
            searchResults.append(todostore.todos[index].filter({ (todo) -> Bool in
                return todo.title.lowercased().contains(searchText.lowercased())
            }))
        }
        
        return searchResults
    }
    
    
}


extension ToDoTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText != "" {
            searchResults = searchToDos(searchText: searchText)
        } else {
            searchResults = []
            for _ in 0..<ToDoStore.shared.getCategoryCount() {
                searchResults.append([])
            }
        }
        tableView.reloadData()
    }
}

extension ToDoTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchText != "" {
            searchResults = searchToDos(searchText: searchText)
            
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults = []
        
        for _ in 0..<ToDoStore.shared.getCategoryCount() {
            searchResults.append([])
        }
        tableView.reloadData()
    }
}

