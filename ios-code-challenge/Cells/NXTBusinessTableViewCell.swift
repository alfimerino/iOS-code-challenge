/*

 */

@objc(NXTBusinessTableViewCell) 
class NXTBusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ratingImageView: UIImageView!
    @IBOutlet var reviewCountLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var categoriesLabel: UILabel!

    @objc static let reuseIdentifier = "NXTBusinessTableViewCellIdentifier"

    func configureCell(business: YLPBusiness) {
        businessImageView.layer.cornerRadius = 5
        businessImageView.image = business.image

        nameLabel.text = business.name
        let image = UIImage(named: business.ratingImageName) //See ratingImageName in YLPBusiness+Additions.swift
        ratingImageView.image = image // Extended YLPBusiness to take an image
        reviewCountLabel.text = "\(business.reviewCount) Reviews"
        distanceLabel.text = "\(business.distanceInMiles)" // See distanceInMiles in YLPBusiness+Additions.swift
        categoriesLabel.text = "\(business.categories.joined(separator: ", "))"
    }
}

// MARK: NXTBindingDataForObjectDelegate

extension NXTBusinessTableViewCell: NXTBindingDataForObjectDelegate {

    func bindingData(for object: Any) {
        guard let object = object as? YLPBusiness else { return }
        configureCell(business: object)
    }
}


