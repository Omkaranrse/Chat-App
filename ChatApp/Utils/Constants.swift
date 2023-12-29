//
//  Constants.swift
//  ChatApp
//
//  Created by Omkar Anarse on 28/12/23.
//

import Foundation
import FirebaseFirestore
import Firebase

struct FirestoreConstants {
    static let UserCollection = Firestore.firestore().collection("users")
    static let MessagesCollection = Firestore.firestore().collection ("messages")
}
