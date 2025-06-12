import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var map = MapFeature.State()
        var myFlights = FlightListFeature.State(flights: [MockData.Flights.create(), MockData.Flights.create()])
        var selectedTab: AppTab = .map
        var currentTrackedFlight: Flight?
    }
    
    enum AppTab: Equatable {
        case map
        case myFlights
        case search
    }
    
    enum Action {
        case onAppear
        case setCurrentTrackedFlight(Flight?)
        case selectTab(AppTab)
        case map(MapFeature.Action)
        case myFlights(FlightListFeature.Action)
        case tabViewBottomAccessoryTapped
    }
    
    @Dependency(\.trackedFlights) private var trackedFlights
    @Dependency(\.continuousClock) private var clock
    
    var body: some ReducerOf<Self> {
        Scope(state: \.map, action: \.map) {
            MapFeature()
        }
        
        Scope(state: \.myFlights, action: \.myFlights) {
            FlightListFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    if let upcomingFlight = await trackedFlights.upcoming {
                        try await self.clock.sleep(for: .seconds(1))
                        await send(.setCurrentTrackedFlight(upcomingFlight), animation: .easeInOut)
                    }
                }
                
            case let .setCurrentTrackedFlight(flight):
                state.currentTrackedFlight = flight
                return .none
                
            case let .selectTab(tab):
                state.selectedTab = tab
                return .none
                
            case .tabViewBottomAccessoryTapped:
                return .run { [selectedTab = state.selectedTab] send in
                    if let flight = await trackedFlights.flights.first {
                        if selectedTab != .myFlights {
                            await send(.selectTab(.myFlights))
                            try await self.clock.sleep(for: .seconds(0.2))
                        }
                        
                        await send(.myFlights(.openDetails(flight, isTracked: true)))
                    }
                }
            default:
                return .none
            }
        }
    }
}
