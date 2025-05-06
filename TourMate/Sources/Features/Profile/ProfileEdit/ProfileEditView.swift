import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProfileEditViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Info")) {
                    TextField("Display Name", text: $viewModel.displayName)
                    TextField("Photo URL", text: $viewModel.photoURL)
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                Button(action: {
                    viewModel.saveChanges {
                        dismiss()
                    }
                }) {
                    if viewModel.isSaving {
                        ProgressView()
                    } else {
                        Text("Save Changes")
                            .fontWeight(.bold)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
            .onAppear {
                viewModel.loadUserInfo()
            }
        }
    }
}

#Preview {
    ProfileEditView()
}
