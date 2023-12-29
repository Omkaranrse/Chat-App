//
//  MessageService.swift
//  ChatApp
//
//  Created by Omkar Anarse on 28/12/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase

struct MessageService {
    
    static let messageCollection = Firestore.firestore().collection("messages")
    
    static func sendMessage(_ messageText : String, toUser user : User){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPatnerId = user.id
        
        let currentUserRef = messageCollection.document(currentUid).collection(chatPatnerId).document()
        let chatPartnerRef = messageCollection.document(chatPatnerId).collection(currentUid)
        
        let messageID = currentUserRef.documentID
        
        let message = Message(
            messageID: messageID,
            fromID: currentUid,
            toID: chatPatnerId,
            messageText: messageText,
            timestamp: Timestamp()
        )
        
        guard let messageData = try? Firestore.Encoder().encode(message) else { return }
        
        currentUserRef.setData(messageData)
        chatPartnerRef.document(messageID).setData(messageData)
    }
    
    //we are not using async await because we want timestamp for realtime chat experinse
    static func observeMessages(chatPartner : User, completion : @escaping([Message]) -> Void){
        
        let chatPartnerID = chatPartner.id
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = messageCollection
            .document(currentUid)
            .collection(chatPartnerID)
            .order(by: "timestamp", descending: false)
        
        query.addSnapshotListener { snapshot, _ in
            //get recent message
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            //decode
            var messages = changes.compactMap { try? $0.document.data(as: Message.self) }
            
            for (index, message) in messages.enumerated() where !message.isFromCurrentUser {
                messages[index].user = chatPartner
            }
            
            completion(messages)
        }
    }
}
