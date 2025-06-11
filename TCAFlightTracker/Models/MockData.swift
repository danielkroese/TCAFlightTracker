import CoreLocation

enum MockData {
    enum Flights {
        static func create() -> Flight {
            Flight(
                id: UUID().uuidString,
                lastUpdated: .now,
                designator: "KL 123",
                codeShares: [],
                aircraft: Aircraft(),
                airline: Airline(
                    designator: "KL",
                    name: "KLM"
                ),
                departure: Flight.Info(
                    scheduled: .now.addingTimeInterval(3600),
                    expected: nil,
                    actual: nil,
                    state: .onTime
                ),
                arrival: Flight.Info(
                    scheduled: .now.addingTimeInterval(7200),
                    expected: nil,
                    actual: nil,
                    state: .onTime
                ),
                departureAirport: Airport(
                    designator: "AMS",
                    city: Airport.City(name: "Amsterdam", countryCode: "NL", timezone: .gmt),
                    location: .init(latitude: 52.3702, longitude: 4.8952)
                ),
                arrivalAirport: Airport(
                    designator: "JFK",
                    city: Airport.City(name: "New York", countryCode: "US", timezone: .gmt),
                    location: .init(latitude: 40.6397, longitude: -73.7789)
                )
            )
        }
    }
}
