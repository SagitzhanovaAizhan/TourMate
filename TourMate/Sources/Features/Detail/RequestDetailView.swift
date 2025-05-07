import SwiftUI
import MapKit

struct RequestDetailView: View {
    let request: Request
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = RequestDetailViewModel()
    @State private var isDescriptionExpanded = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ZStack(alignment: .topTrailing) {
                    TabView {
                        ForEach(request.imageUrls, id: \.self) { url in
                            AsyncImage(url: URL(string: url)) { image in
                                image.resizable().scaledToFill().frame(height: 350).clipped()
                            } placeholder: {
                                Color.gray.opacity(0.2).frame(height: 350)
                            }
                        }
                    }
                    .frame(height: 350)
                    .tabViewStyle(PageTabViewStyle())
                    .ignoresSafeArea()

                    HStack {
                        Button { dismiss() } label: {
                            Circle().fill(.white.opacity(0.9))
                                .frame(width: 36, height: 36)
                                .overlay(Image(systemName: "chevron.left").foregroundColor(.black))
                        }
                        Spacer()
                        Button {
                            viewModel.toggleLike(for: request.id)
                        } label: {
                            Circle().fill(.white.opacity(0.9))
                                .frame(width: 36, height: 36)
                                .overlay(Image(systemName: viewModel.isLiked ? "heart.fill" : "heart").foregroundColor(viewModel.isLiked ? .red : .black))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top)
                }

                // Title and Address
                VStack(alignment: .leading, spacing: 4) {
                    Text(request.title)
                        .font(.custom(AppFont.bold, size: 20))
                    Text(request.address)
                        .font(.custom(AppFont.regular, size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.custom(AppFont.bold, size: 16))

                    Text(request.description)
                        .font(.custom(AppFont.regular, size: 14))
                        .lineLimit(isDescriptionExpanded ? nil : 3)

                    Button(action: {
                        withAnimation {
                            isDescriptionExpanded.toggle()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text(isDescriptionExpanded ? "Read less" : "Read more")
                                .font(.custom(AppFont.regular, size: 14))
                                .foregroundColor(.blue)
                            Image(systemName: isDescriptionExpanded ? "chevron.up" : "chevron.down")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                // Contacts
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contacts")
                        .font(.custom(AppFont.bold, size: 16))
                    if let phone = URL(string: "tel:\(request.phoneNumber.replacingOccurrences(of: " ", with: ""))") {
                        Link(request.phoneNumber, destination: phone)
                            .font(.custom(AppFont.regular, size: 16))
                            .underline()
                    }
                }
                .padding(.horizontal)

                // Address
                VStack(alignment: .leading, spacing: 8) {
                    Text("Address")
                        .font(.custom(AppFont.bold, size: 16))
                    Text(request.address)
                        .font(.custom(AppFont.regular, size: 16))
                }
                .padding(.horizontal)

                // Show in Map
                Button(action: openInMaps) {
                    Text("Show in map")
                        .font(.custom(AppFont.bold, size: 16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#242760"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
        }
        .navigationBarHidden(true)
    }

    private func openInMaps() {
        let coordinate = CLLocationCoordinate2D(latitude: request.location.latitude,
                                                longitude: request.location.longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = request.title
        mapItem.openInMaps()
    }
}

#Preview {
    RequestDetailView(
        request: .init(
            id: "1",
            title: "Shymbulak Mountain Resort",
            description: """
Shymbulak (also known as "Chimbulak") was discovered by amateur skiers in the 1940s. 
Soon after, it became the first downhill route in the Soviet Union. 
Skiers originally needed to climb up the mountain tops on foot (which took roughly 3 hours). 
In 1954 a 1,500 meters ski tow was built. 
Starting from 1961, Shymbulak hosted several USSR Championships and the Silver Edelweisse prize skiing competitions.
""", category: "",
            phoneNumber: "+7 727 331 7777",
            address: "Kerey, Zhanibek khandar 558/1, Almaty 050020",
            location: .init(
                latitude: 43.151232,
                longitude: 77.080516
            ),
            imageUrls: [
                "https://images.unsplash.com/photo-1609262341099-56db29977a16",
                "https://images.unsplash.com/photo-1596462502278-27bfdc403348",
                "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb"
            ],
            createdBy: "user_1234"
        )
    )
}
