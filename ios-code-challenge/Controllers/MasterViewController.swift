//
//  MasterViewControllerS.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MasterViewController: UITableViewController, LocationUpdatesDelegate {

    var detailViewController: DetailViewController?
    var thisAddress: String? = ""

    var address: Address? = nil {
        willSet {
            thisAddress = newValue?.toString()
        }
    }

    var locationHelper: LocationHelper?

    private lazy var query: YLPSearchQuery = {
        let query = YLPSearchQuery(location: "NYC")
        query.term = "Burgers"
        query.sortBy = "distance"
        query.limit = 30
        return query
    }()

    private var isSearching = false
    private var indexTracker: IndexPath?

    private var searchTotal = 0


    lazy private var dataSource: NXTDataSource? = {
        guard let dataSource = NXTDataSource(objects: nil) else { return nil }

        dataSource.tableViewDidReceiveData = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.reloadData()
        }

        dataSource.tableViewDidSelectCell = { [weak self] object in
            guard let strongSelf = self else { return }
            strongSelf.performSegue(withIdentifier: "showDetail", sender: object)
        }

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

    override func viewWillAppear(_ animated: Bool) {
        locationHelper = LocationHelper()
        locationHelper?.locationUpdatesDelegate = self
    }




    override func viewDidLoad() {
        super.viewDidLoad()

        fetchInitialData()

        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        configureSearchController()

    }

    func locationUpdated(lat: Double, lon: Double) {
        locationHelper?.getCoordinateAddress(lat: lat, lon: lon, completion: { (reverseGeocodedAddress) in
            if reverseGeocodedAddress != nil {
                self.address = reverseGeocodedAddress
            }
        })
    }

    /// Fetches the first batch of businesses and loads inital results
    func fetchInitialData() {
        AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in //Makes the network call with query.
            guard
                let strongSelf = self,
                let result = searchResult
                else {
                    self?.presentError(error)
                    return
            }

            strongSelf.searchTotal = Int(result.total)
            strongSelf.dataSource?.setObjects(result.businesses)
            strongSelf.tableView.reloadData()
        })
    }

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

    override func viewDidAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? false
        super.viewDidAppear(animated)
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

extension MasterViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }
}
