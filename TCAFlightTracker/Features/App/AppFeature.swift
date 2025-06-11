import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var map = MapFeature.State()
        var myFlights = FlightListFeature.State(flights: [MockData.Flights.create(), MockData.Flights.create()])
        var selectedTab: AppTab = .map
    }
    
    enum AppTab: Equatable {
        case map
        case myFlights
        case search
    }
    
    enum Action {
        case selectTab(AppTab)
        case map(MapFeature.Action)
        case myFlights(FlightListFeature.Action)
        case tabViewBottomAccessoryTapped
    }
    
    @Dependency(\.trackedFlights) private var trackedFlights
    
    var body: some ReducerOf<Self> {
        Scope(state: \.map, action: \.map) {
            MapFeature()
        }
        
        Scope(state: \.myFlights, action: \.myFlights) {
            FlightListFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .selectTab(tab):
                state.selectedTab = tab
                return .none
                
            case .tabViewBottomAccessoryTapped:
                return .run { send in
                    if let flight = await trackedFlights.flights.first {
                        await send(.selectTab(.myFlights))
                        try? await Task.sleep(for: .seconds(0.2))
                        await send(.myFlights(.openDetails(flight, isTracked: true)))
                    }
                }
            default:
                return .none
            }
        }
    }
}
