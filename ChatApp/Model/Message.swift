//
//  Message.swift
//  ChatApp
//
//  Created by Omkar Anarse on 28/12/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct Message : Identifiable, Codable, Hashable {
    
    @DocumentID var messageID : String?
    let fromID : String
    let toID : String
    let messageText : String
    let timestamp : Timestamp
    
    var user : User?
    
    var id : String {
        return messageID ?? NSUUID().uuidString
    }
    
    var chatPatnerID : String {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
    
    var isFromCurrentUser : Bool {
        return fromID == Auth.auth().currentUser?.uid
    }
    
    var timestampString : String {
        return timestamp.dateValue().timestampString()
    }
}
