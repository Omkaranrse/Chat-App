//
//  SignUpView.swift
//  ChatApp
//
//  Created by Omkar Anarse on 23/12/23.
//
import SwiftUI

struct SignUpView: View {
    
    @StateObject var viewModel = RegistrationViewModel()
    @State private var isPasswordVisible: Bool = false
    @Environment(\.dismiss) var dismiss
    @State private var isLoading: Bool = false

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Spacer()
                
                //Image icon
                Image("image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.37, height: geometry.size.width * 0.37)
                    .padding()
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
 
                //Sign Up Text
                Text("Sign Up")
                    .font(.title)
                    .fontDesign(.serif)
                    .fontWeight(.bold)

                TextFieldWithIcon(systemName: "person", placeholder: "Full name", text: $viewModel.fullName, geometry: geometry)
                TextFieldWithIcon(systemName: "envelope", placeholder: "Email", text: $viewModel.email, geometry: geometry)
                PasswordFieldWithIcon(systemName: "lock", placeholder: "Password", text: $viewModel.password, isSecure: !isPasswordVisible, geometry: geometry)

                Button(action: {
                    Task {
                        isLoading = true
                        do {
                            try await viewModel.createuser()
                        } catch {
                            print(error.localizedDescription)
                        }
                        isLoading = false
                    }
                }) {
                    HStack {
                        if !isLoading {
                            Text("Sign In")
                                .foregroundColor(.white)
                        }
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .opacity(isLoading ? 1 : 0)
                    }
                    .padding()
                    .frame(width: geometry.size.width * 0.9, height: 50)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .disabled(isLoading)

                Spacer()
                Spacer()
                Spacer()

                Divider()

                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Text("Already have an account?")
                        Text("Sign In")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                    .foregroundColor(.black)
                }
            }
            .padding()
        }
    }
}

#Preview {
    SignUpView()
}
