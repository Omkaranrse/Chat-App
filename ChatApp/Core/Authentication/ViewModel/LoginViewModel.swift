//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Omkar Anarse on 25/12/23.
//

import Foundation

class LoginViewModel : ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func login() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
}
