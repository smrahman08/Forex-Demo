//
//  ViewController.swift
//  Forex
//
//  Created by Shabab Rahman on 3/2/19.
//  Copyright © 2019 Shabab Rahman. All rights reserved.
//

import UIKit
import Alamofire
//can be in seperate swift file
extension UISearchController {
    var searchBarIsEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return isActive && !searchBarIsEmpty
    }
    
}



//Declare Conformance
class SymbolTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    var symbols: [String] = []
    var filteredSymbols: [String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //delagete drag thing
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
        //Adding Search Bar Stuff
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Fx Pairs"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        //
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "SymbolTableViewCell"
        )
        let urlString = "https://forex.1forge.com/1.0.3/symbols?api_key=scKdc5njprJwBjonYn417rDniGrve9aM"
        Alamofire.request(urlString).responseJSON { response in
            /// Count Number of Rows I think
            if let responseData = response.data {
                self.symbols = (try? JSONDecoder().decode([String].self, from:
                    responseData)) ?? []
                self.tableView.reloadData()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    // SEGUE TO QOUTE PAGE (this what displays the next)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ??  "" {
        case "SymbolTableViewController_To_SymbolDetailViewController":
            guard let destination = segue.destination as? SymbolDetailViewController else {
                fatalError()
            }
            for indexPath in tableView.indexPathsForSelectedRows ?? [] {
                let passedSymbols = searchController.isFiltering ? filteredSymbols[indexPath.row] : symbols[indexPath.row]
                destination.symbols.append(passedSymbols)
            }
        default:
            fatalError()
        }
    }
    
    //    /// 1) Start feeding data into UItableView (Without SearchBar)
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
    //        Int {
    //            return symbols.count
    //    }
    //2) With Search
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
        Int {
            return searchController.isFiltering ? filteredSymbols.count : symbols.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SymbolTableViewCell")!
        //1 Original
        // cell.textLabel?.text = symbols[indexPath.row]
        //2 Upadted for Search
        cell.textLabel?.text = searchController.isFiltering ? filteredSymbols[indexPath.row] : symbols[indexPath.row]
        //Start selection stuff
        cell.selectionStyle = .none
        let cellIsSelected = tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false
        cell.accessoryType = cellIsSelected ? .checkmark : .none
        return cell
    }
    ////when dragged segue doesnt work for 1
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        //animation
    //        tableView.deselectRow(at: indexPath, animated: true)
    //        //seque
    //        performSegue(withIdentifier: "SymbolTableViewController_To_SymbolDetailViewController", sender: self)
    /// DID SELCT
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark // add checkmark when selecting
        enableDoneButtonIfNecessary()
    }
    //DESELCT
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none /// .none is the diferrence
        enableDoneButtonIfNecessary()
    }
    /// Func to enable bar button item
    func enableDoneButtonIfNecessary() {
        doneBarButtonItem.isEnabled = (tableView.indexPathsForSelectedRows?.count ?? 0) > 0
    }
    
    //Updating Search Results this is the function that feeds the string filteredSymbols
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filteredSymbols = symbols.filter({ (symbols) -> Bool in
            return symbols.contains(searchText.uppercased())
        })
        tableView.reloadData()
        print (filteredSymbols)
    }
    
}
