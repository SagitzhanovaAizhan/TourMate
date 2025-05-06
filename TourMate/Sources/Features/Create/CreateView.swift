import SwiftUI
import PhotosUI
import MapKit

enum RequestType: String, CaseIterable, Identifiable {
    case tour = "Tour"
    case request = "Request"
    var id: String { rawValue }
}

struct MapLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct CreateView: View {
    @StateObject private var viewModel = CreateViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var selectedType: RequestType = .request
    @State private var selectedCoordinate: CLLocationCoordinate2D? = nil
    @State private var showSuccessToast = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if showSuccessToast {
                    Text("Published successfully!")
                        .font(.custom(AppFont.bold, size: 14))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.bottom, 8)
                }

                Text("Create request")
                    .font(.custom(AppFont.bold, size: 24))

                // Photos
                HStack {
                    PhotosPicker(selection: $viewModel.selectedPhotos, maxSelectionCount: 5, matching: .images) {
                        photoBox(icon: "camera", label: "Add")
                    }
                    .onChange(of: viewModel.selectedPhotos) { _ in
                        Task { await viewModel.handlePhotoSelection() }
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.images, id: \.self) { img in
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }

                labeledTextField(icon: "magnifyingglass", placeholder: "I'm searching for…", text: $viewModel.title)

                Picker("Category", selection: $selectedType) {
                    ForEach(RequestType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                TextEditor(text: $viewModel.description)
                    .frame(height: 100)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

                labeledTextField(icon: "phone", placeholder: "Enter phone number", text: $viewModel.phone)
                labeledTextField(icon: "mappin.and.ellipse", placeholder: "Street, home", text: $viewModel.address)

                Map(coordinateRegion: $viewModel.region, annotationItems: selectedCoordinate.map { [MapLocation(coordinate: $0)] } ?? []) { location in
                    MapMarker(coordinate: location.coordinate, tint: .red)
                }
                .frame(height: 200)
                .cornerRadius(12)
                .gesture(
                    TapGesture().onEnded { _ in
                        let center = viewModel.region.center
                        selectedCoordinate = center
                        viewModel.region.center = center
                    }
                )

                Button(action: {
                    viewModel.publishRequest { success in
                        if success {
                            withAnimation {
                                showSuccessToast = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                dismiss()
                            }
                        }
                    }
                }) {
                    if viewModel.isUploading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Publish")
                            .font(.custom(AppFont.bold, size: 16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#242760"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .disabled(viewModel.isUploading || viewModel.title.isEmpty || viewModel.description.isEmpty)
            }
            .padding()
        }
    }

    func photoBox(icon: String, label: String) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 24))
            Text(label)
                .font(.caption)
        }
        .frame(width: 80, height: 80)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }

    func labeledTextField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            TextField(placeholder, text: text)
                .autocorrectionDisabled(true)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}
