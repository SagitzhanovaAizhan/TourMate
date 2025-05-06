import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var showEdit = false
    @State private var user = Auth.auth().currentUser
    @State private var showMyRequests = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                ZStack {
                    VStack(spacing: 8) {
                        Text("My profile")
                            .font(.custom(AppFont.semiBold, size: 22))
                            .padding(.vertical, 20)
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 100, height: 100)
                                .shadow(radius: 3)

                            if let url = user?.photoURL {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 90)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                Text(user?.displayName ?? "No Name")
                    .font(.custom(AppFont.bold, size: 20))
                Text(user?.email ?? "example@email.com")
                    .foregroundColor(.gray)
                    .font(.custom(AppFont.regular, size: 16))
                VStack(spacing: 12) {
                    profileRow(title: "Edit profile", action: {
                        showEdit = true
                    })
                    profileRow(title: "My requests", action: {
                        showMyRequests = true
                    })
                    profileRow(title: "Privacy Policy", action: {})
                    profileRow(title: "FAQ", action: {})
                    Button(action: {
                        sessionManager.signOut()
                    }) {
                        Text("Log Out")
                            .foregroundColor(.red)
                            .font(.custom(AppFont.bold, size: 16))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 16)
                    }
                }
                .padding()
                .padding(.horizontal)
                Spacer()
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .sheet(isPresented: $showEdit, onDismiss: {
                user = Auth.auth().currentUser
            }) {
                ProfileEditView()
            }
            .background(
                NavigationLink(destination: RequestsView(viewState: .myRequests), isActive: $showMyRequests) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }

    @ViewBuilder
    private func profileRow(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.black)
                    .font(.custom(AppFont.semiBold, size: 16))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(hex: "#F8F8F8"))
            .cornerRadius(12)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(SessionManager())
}
