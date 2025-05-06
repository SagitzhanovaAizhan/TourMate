import SwiftUI
import MapKit

struct MapView: View {
    @Binding var cameraPosition: MapCameraPosition
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(position: $cameraPosition) {
                
            }
            .ignoresSafeArea()
            VStack {
                Button(action: {
                    
                }) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(hex: "#195AB5"))
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
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

#Preview {
    MapView(
        cameraPosition: .constant(
            .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 53.9006, longitude: 27.5590),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
        ),
        locationManager: LocationManager()
    )
}
