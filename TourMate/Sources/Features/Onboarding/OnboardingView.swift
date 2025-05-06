import SwiftUI

struct OnboardingView: View {
    struct Page {
        var title: String
        var subtitle: String
        var image: ImageResource
    }
    
    @State private var currentPage = 0
    var onFinish: () -> Void
    
    private let pages: [Page] = [
        .init(title: "Build your\nroutes", subtitle: "and explore exciting places", image: .onboarding1),
        .init(title: "Discover entertainment", subtitle: "and find fun activities", image: .onboarding2),
        .init(title: "Weekdays easier with Tourmate", subtitle: "Help is always at hand", image: .onboarding3),
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 20) {
                        Spacer()
                        Image(pages[index].image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .padding(.horizontal, 40)
                        Spacer()
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(pages[index].title)
                                    .font(.custom(AppFont.bold, size: 28))
                                    .foregroundColor(Color(hex: "#252525"))
                                    .multilineTextAlignment(.leading)
                                Text(pages[index].subtitle)
                                    .font(.custom(AppFont.regular, size: 18))
                                    .foregroundColor(Color(hex: "#929292"))
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 32)
                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: UIScreen.main.bounds.height * 0.75)
            HStack {
                HStack(spacing: 4) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage ? Color(hex: "#242760") : Color(hex: "#929292"))
                            .frame(width: 12, height: 6)
                    }
                }
                Spacer()
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        onFinish()
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(hex: "#242760"))
                        .frame(width: 24, height: 24)
                        .padding()
                        .background(
                            Circle()
                                .stroke(Color(hex: "#242760"), lineWidth: 2)
                        )
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 20)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingView { }
}
