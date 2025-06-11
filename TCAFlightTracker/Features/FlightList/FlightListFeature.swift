import ComposableArchitecture

@Reducer
struct FlightListFeature {
    @ObservableState
    struct State: Equatable {
        var flights: IdentifiedArrayOf<Flight>
        var path = StackState<FlightDetailsFeature.State>()
        
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case flightTapped(Flight)
        case openDetails(Flight, isTracked: Bool)
        case destination(PresentationAction<Destination.Action>)
        case path(StackActionOf<FlightDetailsFeature>)
    }
    
    @Reducer
    enum Destination {
        case openDetails(FlightDetailsFeature)
    }
    
    @Dependency(\.trackedFlights) var trackedFlights
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .flightTapped(flight):
                return .run { send in
                    let isTracked = await self.trackedFlights.flights.contains(flight)
                    
                    await send(.openDetails(flight, isTracked: isTracked))
                }
                
            case let .openDetails(flight, isTracked):
                state.destination = .openDetails(
                    FlightDetailsFeature.State(
                        flight: flight,
                        isTracked: isTracked
                    )
                )
                return .none
                
            case .destination(.presented(.openDetails)):
                return .none
                
            case .destination:
                return .none
                
            case .path:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination.body
        }
        .forEach(\.path, action: \.path) {
            FlightDetailsFeature()
        }
    }
}

extension FlightListFeature.Destination.State: Equatable {}
