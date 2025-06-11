import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    struct State: Equatable {
        var map = MapFeature.State()
        var myFlights = FlightListFeature.State(flights: [MockData.Flights.create(), MockData.Flights.create()])
    }
    
    enum Action {
        case map(MapFeature.Action)
        case myFlights(FlightListFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.map, action: \.map) {
            MapFeature()
        }
        
        Scope(state: \.myFlights, action: \.myFlights) {
            FlightListFeature()
        }
        
        Reduce { state, action in
            return .none
        }
    }
}
