import SwiftUI
import MapKit

struct MapView: View {
    @Binding var cameraPosition: MapCameraPosition
    @ObservedObject var locationManager: LocationManager
    var requests: [Request]
    var onRequestTap: (Request) -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(position: $cameraPosition) {
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

            VStack {
                Button(action: {
                    if let location = locationManager.userLocation {
                        cameraPosition = .region(
                            MKCoordinateRegion(
                                center: location.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            )
                        )
                    }
                }) {
                    Image(systemName: "location.fill")
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(hex: "#195AB5"))
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
            }
            .padding(.bottom, 140)
            .padding(.trailing, 16)
        }
    }
}
