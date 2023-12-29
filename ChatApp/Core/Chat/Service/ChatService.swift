//
//  ChatService.swift
//  ChatApp
//
//  Created by Omkar Anarse on 28/12/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase

struct ChatService {
    
    
    let chatPartner : User
    
    func sendMessage(_ messageText : String){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPatnerId = chatPartner.id
        
        let currentUserRef = FirestoreConstants.MessagesCollection.document(currentUid).collection(chatPatnerId).document()
        let chatPartnerRef = FirestoreConstants.MessagesCollection.document(chatPatnerId).collection(currentUid)
        
        let recentCurrentUserRef =  FirestoreConstants.MessagesCollection.document(currentUid).collection("recent-messages").document(chatPatnerId)
        let recentPartnerRef =  FirestoreConstants.MessagesCollection.document(chatPatnerId).collection("recent-messages").document(currentUid)
        
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
        
        recentCurrentUserRef.setData(messageData)
        recentPartnerRef.setData(messageData)
    }
    
    //we are not using async await because we want timestamp for realtime chat experinse
    func observeMessages(completion : @escaping([Message]) -> Void){
        
        let chatPartnerID = chatPartner.id
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = FirestoreConstants.MessagesCollection
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

