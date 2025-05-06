import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    var onAuthSuccess: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(.logo)
            Text(viewModel.isRegisterMode ? "Register new account" : "Login to access your account")
                .font(.custom(AppFont.regular, size: 16))
                .foregroundColor(Color(hex: "#252525"))
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.gray)
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                    SecureField("Password", text: $viewModel.password)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                if viewModel.isRegisterMode {
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            if !viewModel.isRegisterMode {
                HStack {
                    Button(action: {
                        viewModel.rememberMe.toggle()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: viewModel.rememberMe ? "checkmark.square.fill" : "square")
                                .foregroundColor(viewModel.rememberMe ? .blue : .gray)
                            Text("Remember me")
                                .font(.custom(AppFont.regular, size: 14))
                                .foregroundColor(.black)
                        }
                    }
                    Spacer()
                    Button(action: {
                        Task {
                            await viewModel.resetPassword()
                        }
                    }) {
                        Text("Forgot password")
                            .font(.custom(AppFont.regular, size: 14))
                            .foregroundColor(Color(hex: "#5390E5"))
                    }
                }
                .padding(.horizontal)
            }
            Spacer()
            Button(action: {
                Task {
                    do {
                        if viewModel.isRegisterMode {
                            try await viewModel.register()
                            onAuthSuccess()
                        } else {
                            try await viewModel.signIn()
                            onAuthSuccess()
                        }
                    }
                }
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    HStack {
                        ZStack {
                            Text(viewModel.isRegisterMode ? "Sign up" : "Sign in")
                                .font(.custom(AppFont.bold, size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                            HStack {
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .padding(.trailing, 16)
                            }
                        }
                    }
                    .padding()
                    .background(Color(hex: "#242760"))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty || viewModel.isLoading)
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .font(.custom(AppFont.regular, size: 14))
                    .foregroundColor(.gray)
                Button(action: {
                    withAnimation {
                        viewModel.isRegisterMode.toggle()
                    }
                }) {
                    Text("Sign up")
                        .font(.custom(AppFont.bold, size: 14))
                        .foregroundColor(Color(hex: "#1D1B5E"))
                }
            }
            .padding(.bottom, 16)
        }
        .padding()
        .onAppear {
            viewModel.loadRememberedEmail()
        }
        .alert(isPresented: $viewModel.showAuthErrorAlert) {
            Alert(
                title: Text("Authentication Error"),
                message: Text(viewModel.authErrorMessage ?? "Something went wrong"),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $viewModel.showSuccessAlert) {
            Alert(
                title: Text("Success"),
                message: Text(viewModel.successMessage ?? "Success"),
                dismissButton: .default(Text("OK"))
            )
        }

    }
}

#Preview {
    AuthView(onAuthSuccess: { })
}
