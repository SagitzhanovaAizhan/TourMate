import SwiftUI
import MapKit
import FirebaseDatabase

struct MapScreen: View {
    @State private var cameraPosition = MapCameraPosition.automatic
    @StateObject private var locationManager = LocationManager()
    @State private var isSearchPresented = false
    @State private var selectedRequest: Request? = nil
    @State private var requests: [Request] = []
    @State private var selectedCategory: String? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    Spacer()
                    Menu {
                        Button("All", action: { selectedCategory = nil })
                        Button("Tours", action: { selectedCategory = "Tour" })
                        Button("Requests", action: { selectedCategory = "Request" })
                    } label: {
                        Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }
                .padding([.horizontal, .top])
                
                MapView(
                    cameraPosition: $cameraPosition,
                    locationManager: locationManager,
                    requests: selectedCategory == nil
                        ? requests
                        : requests.filter { $0.category == selectedCategory },
                    onRequestTap: { request in
                        selectedRequest = request
                    }
                )
            }
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
                .padding([.bottom, .horizontal])
            }
        }
        .sheet(isPresented: $isSearchPresented) {
            SearchView(requests: requests) { selected in
                selectedRequest = selected
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: .init(latitude: selected.location.latitude, longitude: selected.location.longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )
            }
            .presentationDragIndicator(.visible)
        }
        .sheet(item: $selectedRequest) { request in
            RequestDetailView(request: request)
        }
        .onAppear {
            locationManager.requestLocation()
            fetchRequests()
        }
    }

    private func fetchRequests() {
        let ref = Database.database().reference().child("requests")
        ref.observeSingleEvent(of: .value) { snapshot in
            var temp: [Request] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let data = try? JSONSerialization.data(withJSONObject: snap.value ?? [:]),
                   let request = try? JSONDecoder().decode(Request.self, from: data) {
                    temp.append(request)
                }
            }
            DispatchQueue.main.async {
                self.requests = temp
            }
        }
    }
}
