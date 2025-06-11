import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        TabView {
            Tab("Map", systemImage: "map") {
                MapView(
                    store: store.scope(state: \.map, action: \.map)
                )
            }
            
            Tab("My Flights", systemImage: "airplane.circle") {
                FlightListView(
                    store: store.scope(state: \.myFlights, action: \.myFlights)
                )
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
  AppView(
    store: Store(initialState: AppFeature.State()) {
      AppFeature()
    }
  )
}
