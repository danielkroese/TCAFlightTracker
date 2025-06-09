import Foundation
import CoreLocation

struct Airport {
    let designator: String
    let city: City
    let location: CLLocation
    
    struct City {
        let name: String
        let countryCode: String
        let timezone: TimeZone
    }
}
