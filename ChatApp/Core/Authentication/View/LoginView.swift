//
//  LoginView.swift
//  ChatApp
//
//  Created by Omkar Anarse on 23/12/23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    @State private var isPasswordVisible: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack(spacing: 15) {
                    
                    Spacer()
                    // Image icon
                    Image("image")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.37, height: geometry.size.width * 0.37)
                        .padding()
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
                    
                    // Sign Up Text
                    Text("Sign In")
                        .font(.title)
                        .fontDesign(.serif)
                        .fontWeight(.bold)

                    TextFieldWithIcon(systemName: "envelope", placeholder: "Email", text: $viewModel.email, geometry: geometry)
                    PasswordFieldWithIcon(systemName: "lock", placeholder: "Password", text: $viewModel.password, isSecure: !isPasswordVisible, geometry: geometry)

                    // Forget password
                    Button(action: {
                        print("Forget password")
                    }) {
                        Text("Forget password?")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .padding(.top)
                            .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 28)
                    
                    // Login view
                    Button(action: {
                        Task {
                            isLoading = true
                            do {
                                try await viewModel.login()
                            } catch {
                                print(error.localizedDescription)
                            }
                            isLoading = false
                        }
                    }) {
                        HStack {
                            if !isLoading {
                                Text("Login")
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

                    HStack {
                        Rectangle()
                            .frame(width: (geometry.size.width / 2) - 40, height: 0.5)
                        
                        Text("OR")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        Rectangle()
                            .frame(width: (geometry.size.width / 2) - 40, height: 0.5)
                    }
                    .foregroundStyle(Color.gray)
                    .padding(.top, 8)
                    
                    HStack {
                        Image("facebook")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Text("Continue with Facebook")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(uiColor: .systemBlue))
                    }
                    .padding(.top, 8)

                    Spacer()
                    Spacer()
                    
                    Divider()
                    
                    NavigationLink {
                        SignUpView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        HStack {
                            Text("Don't have an account?")
                            Text("Sign Up")
                                .fontWeight(.semibold)
                        }
                        .font(.footnote)
                        .foregroundColor(.black)
                    }
                }
            }
        }
    }
}


#Preview {
    LoginView()
}
