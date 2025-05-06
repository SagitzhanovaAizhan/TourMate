import SwiftUI

struct SplashscreenView: View {
    var body: some View {
        ZStack {
            Color(hex: "#5390E5")
                .ignoresSafeArea()
            Image(.splashscreen)
            Image(systemName: "trash")
        }
    }
}


#Preview {
    SplashscreenView()
}
