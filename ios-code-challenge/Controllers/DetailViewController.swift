//
//  DetailViewController.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var businessImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ratingImageView: UIImageView!
    @IBOutlet var reviewCountLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var categoriesLabel: UILabel!
    @IBOutlet var priceImageView: UIImageView!

    lazy private var favoriteBarButtonItem: UIBarButtonItem = {
        let image = UIImage(named: "Star-Outline")
        let button = UIBarButtonItem(image: image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(onFavoriteBarButtonSelected(_:)))
        return button
    }()

    @objc var detailItem: YLPBusiness?
    
    private var _favorite: Bool = false
    private var isFavorite: Bool {
        get {
            return _favorite
        } 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeHolders()
        navigationItem.rightBarButtonItems = [favoriteBarButtonItem]
        configureView()
    }

    func setDetailItem(newDetailItem: YLPBusiness) {
        guard detailItem != newDetailItem else { return }

        detailItem = newDetailItem
    }

    func placeHolders() {
        businessImageView.image = #imageLiteral(resourceName: "yelpOpaque")
        nameLabel.text = ""
        reviewCountLabel.text = ""
        distanceLabel.text = ""
        categoriesLabel.text = ""
//        priceImageView.image =
    }

    private func configureView() {
        guard let detailItem = detailItem else { return }
        
        businessImageView.image = detailItem.image
        nameLabel.text = detailItem.name
        ratingImageView.image = UIImage(named: detailItem.ratingImageName) //See ratingImageName in YLPBusiness+Additions.swift
        reviewCountLabel.text = "\(detailItem.reviewCount) Reviews"
        distanceLabel.text = detailItem.distanceInMiles // See distanceInMiles in YLPBusiness+Additions.swift
        categoriesLabel.text = "\(detailItem.categories.joined(separator: ", "))"
        priceImageView.image = UIImage(named: detailItem.priceImageName) // See priceImageName in YLPBusiness+Additions.swift
    }
   
    private func updateFavoriteBarButtonState() {
        favoriteBarButtonItem.image = isFavorite ? UIImage(named: "Star-Filled") : UIImage(named: "Star-Outline")
    }
    
    @objc private func onFavoriteBarButtonSelected(_ sender: Any) {
        _favorite.toggle()
        updateFavoriteBarButtonState()
    }
}
