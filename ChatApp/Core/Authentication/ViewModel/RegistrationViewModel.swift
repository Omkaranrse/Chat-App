//
//  RegistrationViewModel.swift
//  ChatApp
//
//  Created by Omkar Anarse on 25/12/23.
//

import Foundation
import SwiftUI

class RegistrationViewModel : ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullName = ""
    
    func createuser() async throws {
        try await AuthService.shared.createUser(withEmail: email, password: password, fullName: fullName)
    }

}
