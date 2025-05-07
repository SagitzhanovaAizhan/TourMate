import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    let requests: [Request]
    var onSelect: (Request) -> Void

    private var filteredRequests: [Request] {
        if searchText.isEmpty {
            return requests
        } else {
            return requests.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $searchText)
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.top)

            if filteredRequests.isEmpty {
                Text("Nothing found")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(filteredRequests) { request in
                            Button(action: {
                                onSelect(request)
                                dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(.blue)
                                    Text(request.title)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }

            Spacer()
        }
        .background(Color(.systemGray6))
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}
