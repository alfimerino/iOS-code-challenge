//
//  MasterViewControllerS.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit
import MapKit

class MasterViewController: UITableViewController{

    var detailViewController: DetailViewController?

    // MARK: - Creates the YLPSearchQuery Object to work with Network call.
    private let query: YLPSearchQuery = {
        let query = YLPSearchQuery(location: "San Jose")
        query.term = "Sandwiches"
        query.sortBy = "distance"
//        query.limit = 30
        return query
    }()

    private var isSearching = false // Status for searchView.
    private var searchTotal = 0 // Variale to hold total number of businesses found from network call.

    // MARK: - Provided NXTDataSource + Additions
    lazy private var dataSource: NXTDataSource? = {
        guard let dataSource = NXTDataSource(objects: nil) else { return nil }

        dataSource.tableViewDidReceiveData = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.reloadData()
        }
        /*
         tableViewDidSelectCell - Used to perform the segue and send the data to the detailVC
         */
        dataSource.tableViewDidSelectCell = { [weak self] object in
            guard let strongSelf = self else { return }
            strongSelf.performSegue(withIdentifier: "showDetail", sender: object)
        }
        /*
         tableViewWillDisplay - Used to access lifecycle method that will allow access to indexPath.
         1. Sets the total number of businesses to the dataSource.
         2. If the indexPath reaches the 5th last cell, calls fetchNextPage() for the next
            number of businesses to display.
        */
        dataSource.tableViewWillDisplay = { [weak self] indexPath in
            if self?.searchTotal == dataSource.objects.count {
                return
            }

            guard let indexPath = indexPath as? IndexPath else { return }

            if indexPath.row >= dataSource.objects.count - 5 {
                self?.fetchNextPage()
            }
        }

        return dataSource
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchInitialData() 

        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        configureSearchController()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? false
        super.viewDidAppear(animated)
    }

    // MARK: - fetchInitialData()
    /*
     Fetches the first batch of businesses and loads inital results.
     1. AFYelpAPIClient closure makes the network call and return searchResult and error.
     2. IF - network call fails, presents error to user.
     3. ELSE - network call is successfull, searchTotal is set for the total number of businesses found matching the query.
     4. DataSource is set with the objects fetched from the successful result.
     5. TableView reloads data with dataSource objects.
    */
    func fetchInitialData() {
        AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in //Makes the network call with query.
            guard
                let strongSelf = self, // Added to remove confusion.
                let result = searchResult // Sets the result to the YLPSearch object.
                else {
                    self?.presentError(error) // Presents error if network call fails.
                    return
            }

            strongSelf.searchTotal = Int(result.total)
            strongSelf.dataSource?.setObjects(result.businesses) //Sets the offset number of businesses for the initial search.
            strongSelf.tableView.reloadData()
        })
    }

    // MARK: - fetchNextPage()
    /*
     Fetches the next set of businesses from API.
     1. AFYelpAPIClient closure makes the network call and return searchResult and error.
     2. IF - network call fails, presents error to user.
     3. ELSE - network call is successfull, searchTotal is set for the total number of businesses found matching the query.
     4. DataSource appends objects fetched from the successful result.
     5. TableView reloads data with dataSource objects.
    */
    func fetchNextPage() {
        AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in

            guard
                let strongSelf = self,
                let result = searchResult
                else {
                    self?.presentError(error)
                    return
            }

            strongSelf.searchTotal = Int(result.total)
            strongSelf.dataSource?.appendObjects(result.businesses)
        })
    }

    //MARK: - presentError()
    // - Presents UIAlertController if error has occurred in fetchInitialData() or fetchNextPage()
    func presentError(_ error: Error?) {
        let errorMessage = error?.localizedDescription ?? ""
        let alert = UIAlertController(title: "Error",
                                      message: "An error occurred fetching data\n\(errorMessage)",
            preferredStyle: .alert)

        present(alert, animated: true, completion: nil)
    }

    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.barTintColor = .white
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard
                let indexPath = tableView.indexPathForSelectedRow,
                let object = dataSource?.objects[indexPath.row] as? YLPBusiness
                else {
                    assertionFailure("Failed find and cast object")
                    return
            }

            guard
                let navController = segue.destination as? UINavigationController,
                let controller = navController.topViewController as? DetailViewController
                else {
                    assertionFailure("Failed find rootVC")
                    return
            }

            controller.setDetailItem(newDetailItem: object)
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}

extension MasterViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        //        dataSource?.setFilteredObjects(dataSource?.objects)
        tableView.reloadData()
    }
}


