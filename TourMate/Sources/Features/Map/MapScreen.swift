import SwiftUI
import MapKit

struct MapScreen: View {
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 53.9006, longitude: 27.5590),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    @State private var isSearchPresented = false
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack(alignment: .bottom) {
            MapView(cameraPosition: $cameraPosition, locationManager: locationManager)
            VStack(spacing: 16) {
                Button(action: {
                    isSearchPresented.toggle()
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                            .font(.custom(AppFont.regular, size: 16))
                        Spacer()
                    }
                    .foregroundStyle(Color(hex: "#195AB5"))
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 4)
                }
                .padding(.horizontal)
                .pickerStyle(.segmented)
                .background(Color(.systemBackground))
                .padding([.bottom, .horizontal])
            }
        }
        .sheet(isPresented: $isSearchPresented) {
            SearchView()
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

#Preview {
    MapScreen()
}
