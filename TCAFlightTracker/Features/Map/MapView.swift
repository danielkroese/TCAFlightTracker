import ComposableArchitecture
import SwiftUI
import MapboxMaps

struct MapView: View {
    let store: StoreOf<MapFeature>
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Map(initialViewport: .camera(center: .init(latitude: 27.2, longitude: -26.9), zoom: 1.53, bearing: 0, pitch: 0)) {
            MapViewAnnotation(coordinate: .amsterdam) {
                Circle()
                    .fill(.purple)
                    .frame(width: 40, height: 40)
            }

             PolygonAnnotation(polygon: Polygon(center: .amsterdam, radius: 8 * 100, vertices: 60))
                .fillColor(StyleColor(.yellow))


            GeoJSONSource(id: "source")
                .data(.geometry(.polygon(Polygon(center: .amsterdam, radius: 4 * 100, vertices: 60))))

            FillLayer(id: "fill-id", source: "source")
                .fillColor(.green)
                .fillOpacity(0.7)
        }
        .mapStyle(.standard(lightPreset: colorScheme == .light ? .day : .dusk))
        .ignoresSafeArea()
    }
}

extension CLLocationCoordinate2D {
    static let apple = CLLocationCoordinate2D(latitude: 37.3326, longitude: -122.0304)
    static let zero = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    static let helsinki = CLLocationCoordinate2D(latitude: 60.167488, longitude: 24.942747)
    static let berlin = CLLocationCoordinate2D(latitude: 52.5170365, longitude: 13.3888599)
    static let london = CLLocationCoordinate2D(latitude: 51.5073219, longitude: -0.1276474)
    static let newYork = CLLocationCoordinate2D(latitude: 40.7306, longitude: -73.9866)
    static let dc = CLLocationCoordinate2D(latitude: 38.889215, longitude: -77.039354)
    static let saigon = CLLocationCoordinate2D(latitude: 10.823099, longitude: 106.629662)
    static let hanoi = CLLocationCoordinate2D(latitude: 21.027763, longitude: 105.834160)
    static let tokyo = CLLocationCoordinate2D(latitude: 35.689487, longitude: 139.691711)
    static let bangkok = CLLocationCoordinate2D(latitude: 13.756331, longitude: 100.501762)
    static let jakarta = CLLocationCoordinate2D(latitude: -6.175110, longitude: 106.865036)
    static let kyiv = CLLocationCoordinate2D(latitude: 50.541, longitude: 30.498)
    static let tunis = CLLocationCoordinate2D(latitude: 36.806, longitude: 10.1815)
    static let barcelona = CLLocationCoordinate2D(latitude: 41.3874, longitude: 2.168)
    static let amsterdam = CLLocationCoordinate2D(latitude: 52.3702, longitude: 4.8952)
}
