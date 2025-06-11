import ComposableArchitecture
import SwiftUI
import MapKit

struct MapView: View {
    let store: StoreOf<MapFeature>
    
    var body: some View {
        Map()
    }
}
