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
            
            Tab("My Flights", systemImage: "airplane") {
                FlightListView(
                    store: store.scope(state: \.myFlights, action: \.myFlights)
                )
            }
            
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                Text("Search")
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewBottomAccessoryCompat(true) {
            Text("Your current flight")
        }
    }
}

#Preview {
  AppView(
    store: Store(initialState: AppFeature.State()) {
      AppFeature()
    }
  )
}

extension View {
    @ViewBuilder func tabViewBottomAccessoryCompat<Content: View>(_ isVisible: Bool, content: () -> Content) -> some View {
        if isVisible, #available(iOS 26, *) {
            self.tabViewBottomAccessory {
                content()
            }
        } else {
            content()
        }
    }
}
