//
//  User.swift
//  ChatApp
//
//  Created by Omkar Anarse on 24/12/23.
//

import Foundation
import FirebaseFirestore

struct User : Codable, Identifiable, Hashable {
    
    @DocumentID var documentID : String?
    let fullName : String?
    let email : String
    var profileImageUrl : String?
     
    var id: String {
        return documentID ?? NSUUID().uuidString
    }
    
    var firstName: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName ?? "") {
            return components.givenName ?? fullName ?? ""
        } else {
            return fullName ?? ""
        }
    }
}

extension User{
    static let MOCK_USER = User(fullName: "Omkar", email: "omkar@gmail.com", profileImageUrl: "facebook")
}
