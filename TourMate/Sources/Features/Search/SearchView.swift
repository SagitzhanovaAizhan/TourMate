import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    private let recommendations = [
        "Almaty City Tour",
        "Big Almaty Lake",
        "Kok-Tobe Park",
        "Medeu Skating Rink"
    ]

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $searchText)
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.top)
            HStack {
                Text("Recommendations")
                    .font(.custom(AppFont.bold, size: 18))
                    .foregroundColor(.black)
                    .padding(.horizontal)
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(recommendations, id: \.self) { recommendation in
                        VStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .frame(width: 160, height: 120)
                                .overlay(
                                    Text(recommendation)
                                        .font(.custom(AppFont.regular, size: 14))
                                        .foregroundColor(.black)
                                        .padding(),
                                    alignment: .bottomLeading
                                )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
            Spacer()
        }
        .background(Color(.systemGray5))
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

#Preview {
    SearchView()
}
