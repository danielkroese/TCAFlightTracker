import ComposableArchitecture
import SwiftUI

@main
struct FlightTrackerApp: App {
    enum Dependencies {
        @MainActor
        static let store = Store(initialState: AppFeature.State()) {
            AppFeature()
                ._printChanges()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: Dependencies.store)
        }
    }
}
