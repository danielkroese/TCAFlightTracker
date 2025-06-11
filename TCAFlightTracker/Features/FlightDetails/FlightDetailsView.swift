import ComposableArchitecture
import SwiftUI

struct FlightDetailsView: View {
    let store: StoreOf<FlightDetailsFeature>
    
    var body: some View {
        VStack {
            Text("Flight Details")
            
            Button {
                store.send(.trackButtonTapped)
            }  label: {
                Text(store.isTracked ? "Untrack Flight" : "Track Flight")
            }
        }
    }
}

#Preview {
    FlightDetailsView(
        store: Store(
            initialState: .init(
                flight: MockData.Flights.create(),
                isTracked: false
            )
        ) {
            FlightDetailsFeature()
        }
    )
}
