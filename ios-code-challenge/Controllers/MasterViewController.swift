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

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController?

    private let query: YLPSearchQuery = {
        let query = YLPSearchQuery(location: "1201 Parkmoor Ave San Jose")
        query.term = "Burgers"
        query.sortBy = "distance"
        query.limit = 30
        return query
    }()

    private var isSearching = false
    private var indexTracker: IndexPath?

    private var searchTotal = 0

    let locationManager = CLLocationManager()
    var currentLocation: String = ""

    let geoCoder = CLGeocoder()
    var address = ""

    // MARK: - Sames
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
    //MARK: - Samess

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        locationManager.requestLocation()
        currentLocation = String(describing: locationManager.location)

        fetchInitialData()

        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        configureSearchController()
//        currentLocation = reverseGeocoder()
        guard let location = locationManager.location else { return }
        geoCoder.reverseGeocodeLocation(location) { [weak self]  ( placemarks, error) in
                    guard let self = self else { return }

                    if let _ = error {
                        return
                    }

                    guard let placemark = placemarks?.first else {
                        return
                    }

                    let streetNumber = placemark.subThoroughfare
                    let streetName = placemark.thoroughfare
                    let city = placemark.locality

            self.address = "\(String(describing: streetNumber)) \(String(describing: streetName))"
                    return
                }
    }

    /// Fetches the first batch of businesses and loads inital results
    func fetchInitialData() {
        AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in

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


    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager() // Setup location manager
            checkLocationAuthorization()
        } else {

        }
    }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:

            break
        case .authorizedAlways:
            break
        }
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



    func reverseGeocoder(location: CLLocation) -> String{
        let geoCoder = CLGeocoder()
        var address = ""

        guard let location = locationManager.location else { return ""}

        geoCoder.reverseGeocodeLocation(location) { [weak self]  ( placemarks, error) in
            guard let self = self else { return }

            if let _ = error {

                return
            }

            guard let placemark = placemarks?.first else {
                return
            }

            let streetNumber = placemark.subThoroughfare
            let streetName = placemark.thoroughfare
//            let city = placemark.locality

            address = "\(String(describing: streetNumber)) \(String(describing: streetName))"
            return
        }

        return address
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

//extension MasterViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//
//    }
//}

