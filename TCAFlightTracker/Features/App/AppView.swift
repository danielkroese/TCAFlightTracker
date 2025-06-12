import ComposableArchitecture
import SwiftUI

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        TabView(selection: $store.selectedTab.sending(\.selectTab)) {
            Tab("Map", systemImage: "map", value: .map) {
                MapView(
                    store: store.scope(state: \.map, action: \.map)
                )
            }
            
            Tab("My Flights", systemImage: "airplane", value: .myFlights) {
                NavigationStack {
                    FlightListView(
                        store: store.scope(state: \.myFlights, action: \.myFlights)
                    )
                    .navigationTitle("My Flights")
                }
            }
            
            Tab("Search", systemImage: "magnifyingglass", value: .search, role: .search) {
                NavigationStack {
                    Text("Search")
                        .navigationTitle("Search")
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewBottomAccessoryCompat(store.currentTrackedFlight != nil) {
            Button {
                store.send(.tabViewBottomAccessoryTapped)
            } label: {
                HStack {
                    Image(systemName: "airplane")
                    
                    Text("Your upcoming flight")
                }
                .foregroundStyle(.primary)
            }
            .buttonStyle(.plain)
        }
        .onAppear {
            store.send(.onAppear)
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
        if #available(iOS 26, *) {
            self.tabViewBottomAccessory {
                if isVisible { content() } else { EmptyView() }
            }
        } else {
            self
        }
    }
}
