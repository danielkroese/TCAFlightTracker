import ComposableArchitecture
import SwiftUI

struct FlightListView: View {
    @Bindable var store: StoreOf<FlightListFeature>
    
    var body: some View {
        List(store.flights) { flight in
            Button {
                store.send(.flightTapped(flight))
            } label: {
                Text(flight.designator)
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .sheet(item: $store.scope(state: \.destination?.openDetails, action: \.destination.openDetails)) { store in
            NavigationStack {
                FlightDetailsView(store: store)
            }
        }
    }
}

#Preview {
    FlightListView(
        store: Store(initialState: FlightListFeature.State(
            flights: [MockData.Flights.create()]
        )) {
            FlightListFeature()
        }
    )
}
