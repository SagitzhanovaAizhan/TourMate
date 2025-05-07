import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            MapScreen()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ChatView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
            CreateView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Create")
                }
            RequestsView(viewState: .saved)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Saved")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    MainView()
}
