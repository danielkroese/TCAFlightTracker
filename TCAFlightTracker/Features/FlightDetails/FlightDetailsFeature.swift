import ComposableArchitecture

@Reducer
struct FlightDetailsFeature {
    @ObservableState
    struct State: Equatable {
        var flight: Flight
        var isTracked: Bool
    }
    
    enum Action {
        case trackButtonTapped
        case trackFlight
        case untrackFlight
    }
    
    @Dependency(\.trackedFlights) var trackedFlights
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .trackButtonTapped:
                if state.isTracked {
                    return .send(.untrackFlight)
                } else {
                    return .send(.trackFlight)
                }
                
            case .trackFlight:
                let flight = state.flight
                state.isTracked = true
                
                return .run { _ in
                    await trackedFlights.track(flight)
                }
                
            case .untrackFlight:
                let flight = state.flight
                state.isTracked = false
                
                return .run { _ in
                    await trackedFlights.untrack(flight)
                }
            }
        }
    }
}

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
