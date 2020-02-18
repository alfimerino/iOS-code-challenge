/*
 This Extensions file computes all of the values for YLPBusiness.
 */

extension YLPBusiness {

    // MARK: - Takes the rating value and converts it to a Double. Switch Statement assigns appropriate asset name based on the rating range.
    var ratingImageName: String {
        guard let ratingDouble = Double(rating) else { return "" }

        switch ratingDouble {
        case 0...1.0:   return "1Rating"
        case 1.0...1.5: return "1.5Rating"
        case 1.5...2.0: return "2Rating"
        case 2.0...2.5: return "2.5Rating"
        case 2.5...3.0: return "3Rating"
        case 3.0...3.5: return "3.5Rating"
        case 3.5...4.0: return "4Rating"
        case 4.0...4.5: return "4.5Rating"
        case 4.5...5.0: return "5Rating"
        default: return ""
        }
    }

    var priceImageName: String {

        switch price.count {
        case 0: return "0Price"
        case 1: return "1Price"
        case 2: return "2Price"
        case 3: return "3Price"
        case 4: return "4Price"
        default: return ""
        }
    }

    // MARK: - Computes the distance from meters to miles and truncates the decimal places to 2.
    var distanceInMiles: String {
        guard Double(distance) != nil else { return ""}

        let distanceDub = Double("\(distance)")! * 0.000621371
        let distanceInMiles = "Distance: \(distanceDub.truncate(to: 2)) miles"
        return distanceInMiles
    }
}


// MARK: - Truncates decimals in Double. Needed to compute miles calculation.
extension Double {

    func truncate(to places: Int) -> Double {
        return Double(Int(pow(10, Double(places)) * self)) / pow(10, Double(places))
    }

}
