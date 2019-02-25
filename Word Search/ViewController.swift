//
//  ViewController.swift
//  Word Search
//
//  Created by Linus Huzell on 2019-02-24.
//  Copyright © 2019 Linus Huzell. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchResultsUpdating {
    
    /// Constants & Variables
    let url = "http://runeberg.org/words/ss100.txt"
    let segueIdentifier = "displayWordSegue"
    let searchController = UISearchController(searchResultsController: nil)
    
    var wordArr = [String]()
    var filteredWordArr = [String]()
    var searching : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordArr = getWordsFromServer()
        setupNavBar()
        searching = false
    }
    
    /// Sets options for Navigation Bar and Search Controller.
    func setupNavBar() {
        /// Options for Titles in Navigation Bar.
        navigationController?.navigationBar.prefersLargeTitles = true
        
        /// Options for Search Controller.
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for words here..."
        searchController.definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    /// Gets called whenever user types something new into the Search Bar.
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        searching = true
        
        /// Searching (case insensitive) for text entered by user.
        filteredWordArr = wordArr.filter{ $0.localizedCaseInsensitiveContains(searchText) }
        
        print(filteredWordArr.count)
        print(searchController.isActive)
        if(filteredWordArr.count == 0 && searchController.isActive == true){
            searching = true;
        } else if (filteredWordArr.count == 0 && searchController.isActive == false){
            searching = false;
        } else {
            searching = true
        }
        self.tableView.reloadData()
    }
    
    /// Creating cells for Table View.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let currentWord: String

        if searching {
            currentWord = filteredWordArr[indexPath.row]
        } else{
            currentWord = wordArr[indexPath.row]
        }
        cell.textLabel?.text = currentWord
        return cell
    }
    
    /// Returning number of rows to create.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filteredWordArr.count
        }
        return wordArr.count
    }
    
    /// Downloads the words from server.
    ///
    /// - Returns: An array of strings containing words with first letter uppercased.
    func getWordsFromServer () -> [String]{
        var returnArr = [String]()
        if let downloadUrl = URL(string: url) {
            do {
                let contentString = try String(contentsOf: downloadUrl, encoding: String.Encoding.windowsCP1252)
                let contentArr = contentString.components(separatedBy: "\n")
                returnArr = contentArr.map { $0.prefix(1).uppercased() + $0.dropFirst()}
                return returnArr
            }
            catch {
                self.present(generateErrorAlert(error: error), animated: true)
            }
        }
        returnArr = [""]
        return returnArr
    }
    
    /// Generate an alert for connection errors.
    ///
    /// - Parameter error: Error object catched.
    /// - Returns: An UIAlertController with proper settings and error message.
    func generateErrorAlert(error: Error) -> UIAlertController {
        let alert = UIAlertController(title: "Error connecting to server!", message: "There was an error connecting to the server, try to refresh.\n\(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Refresh", style: .default, handler: {(alert: UIAlertAction!) in self.viewDidLoad()}))
        return alert
    }
    
    /// Preparing for segue. Setting variables at destination View Controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == segueIdentifier{
            let destination = segue.destination as! WordDisplayViewController
            guard let index = tableView.indexPathForSelectedRow?.row else {return}
                if searching {
                    destination.wordToDisplay = filteredWordArr[index]
                }
                else {
                    destination.wordToDisplay = wordArr[index]
                }
            }
        }
    
    /// Performing segue to next view controller when cell is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
}

