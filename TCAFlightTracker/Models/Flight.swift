import Foundation

struct Flight: Equatable, Identifiable, Hashable {
    let id: String
    let lastUpdated: Date
    
    let designator: String
    let codeShares: [String]
    
    let aircraft: Aircraft
    let airline: Airline
    
    let departure: Info
    let arrival: Info
    
    let departureAirport: Airport
    let arrivalAirport: Airport
    
    struct Info: Equatable, Hashable {
        let scheduled: Date
        let expected: Date?
        let actual: Date?
        let state: State
        
        enum State: Equatable, Hashable {
            case scheduled
            case onTime
            case delayed(Duration)
            case early(Duration)
            case canceled
            case diverted(to: Airport)
        }
    }
}

// TODO: Unit test
extension Flight.Info {
    var mostActual: Date {
        return actual ?? expected ?? scheduled
    }
    
    var delay: Duration? {
        guard mostActual != scheduled else {
            return nil
        }
        
        return .seconds(mostActual.timeIntervalSince(scheduled))
    }
    
    var isDelayed: Bool {
        guard let delay else {
            return false
        }
        
        return delay > .zero
    }
    
    var isEarly: Bool {
        guard let delay else {
            return false
        }
        
        return delay < .zero
    }
}
