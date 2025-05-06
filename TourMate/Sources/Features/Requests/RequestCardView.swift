import SwiftUI

struct RequestCardView: View {
    let request: Request
    let isLiked: Bool
    let onLikeTapped: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let url = request.imageUrls.first, let imageURL = URL(string: url) {
                AsyncImage(url: imageURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(request.title)
                        .font(.custom(AppFont.bold, size: 16))
                        .lineLimit(1)
                    Spacer()
                    Button(action: onLikeTapped) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .gray)
                    }
                }
                Text(request.description)
                    .font(.custom(AppFont.regular, size: 14))
                    .foregroundColor(.black)
                    .lineLimit(4)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}
