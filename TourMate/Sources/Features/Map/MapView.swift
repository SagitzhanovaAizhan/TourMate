import SwiftUI
import MapKit

struct MapView: View {
    @Binding var cameraPosition: MapCameraPosition
    @ObservedObject var locationManager: LocationManager
    var requests: [Request]
    var onRequestTap: (Request) -> Void

    @Namespace var mapScope
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
                Map(position: $cameraPosition, scope: mapScope) {
                    ForEach(requests) { request in
                        Annotation(
                            request.title,
                            coordinate: .init(latitude: request.location.latitude, longitude: request.location.longitude)
                        ) {
                            Button(action: {
                                onRequestTap(request)
                            }) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                            }
                        }
                    }
                }
                .ignoresSafeArea()
                MapUserLocationButton(scope: mapScope)
                .padding(.bottom, 140)
                .padding(.trailing, 16)
            }
            .mapScope(mapScope)
    }
}
