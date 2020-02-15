
import Foundation
@objc(NXTBusinessTableViewCell)
class NXTBusinessTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    
    @objc static let reuseIdentifier = "NXTBusinessTableViewCellIdentifier"

    func configureCell(business: YLPBusiness) {
        nameLabel.text = business.name

    }
}

// MARK: NXTBindingDataForObjectDelegate

extension NXTBusinessTableViewCell: NXTBindingDataForObjectDelegate {

    func bindingData(for object: Any) {
        guard let object = object as? YLPBusiness else { return }
        configureCell(business: object)
    }
}
