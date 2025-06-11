import Foundation
import CoreLocation

struct Airport: Equatable, Hashable {
    let designator: String
    let city: City
    let location: CLLocation
    
    struct City: Equatable, Hashable {
        let name: String
        let countryCode: String
        let timezone: TimeZone
    }
}
