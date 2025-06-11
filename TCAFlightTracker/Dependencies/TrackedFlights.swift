import ComposableArchitecture

extension DependencyValues {
    var trackedFlights: TrackedFlights {
        get { self[TrackedFlightsKey.self] }
        set { self[TrackedFlightsKey.self] = newValue }
    }
}

private enum TrackedFlightsKey: DependencyKey {
    static let liveValue = TrackedFlights(flights: [MockData.Flights.create()])
}

actor TrackedFlights: Sendable {
    private(set) var flights: Set<Flight>
    
    init(flights: Set<Flight> = []) {
        self.flights = flights
    }
    
    func track(_ flight: Flight) {
        flights.insert(flight)
    }
    
    func untrack(_ flight: Flight) {
        flights.remove(flight)
    }
}
