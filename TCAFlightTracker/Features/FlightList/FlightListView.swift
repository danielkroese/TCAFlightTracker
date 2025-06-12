import ComposableArchitecture
import SwiftUI

struct FlightListView: View {
    @Bindable var store: StoreOf<FlightListFeature>
    
    @Namespace private var transition
    
    var body: some View {
        List(store.flights) { flight in
            Button {
                store.send(.flightTapped(flight))
            } label: {
                Text(flight.designator)
            }
            .matchedTransitionSource(id: "zoom", in: transition)
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
                .scrollEdgeEffectStyleCompat()
        .safeAreaInset(edge: .bottom, alignment: .center, spacing: 0) {
            Color.clear
                .frame(height: 200)
                .background(Gradient(colors: [.clear, .blue.opacity(0.1)]))
        }
        
        .navigationDestination(item: $store.scope(state: \.destination?.openDetails, action: \.destination.openDetails)) { store in
            NavigationStack {
                FlightDetailsView(store: store)
                    .navigationTransition(.zoom(sourceID: "zoom", in: transition))
            }
        }
        .task {
            store.send(.updateFlights)
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

extension View {
    @ViewBuilder func scrollEdgeEffectStyleCompat() -> some View {
        if #available(iOS 26, *) {
            self.scrollEdgeEffectStyle(.hard, for: .bottom)
        } else {
            self
        }
    }
}
