import SwiftUI
import PhotosUI

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProfileEditViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Info")) {
                    TextField("Display Name", text: $viewModel.displayName)
                    PhotosPicker(selection: $viewModel.selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        HStack {
                            Text("Select Profile Photo")
                            Spacer()
                            if let image = viewModel.selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .onChange(of: viewModel.selectedPhoto) {
                        Task {
                            await viewModel.handlePhotoSelection()
                        }
                    }
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
