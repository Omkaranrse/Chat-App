//
//  InboxService.swift
//  ChatApp
//
//  Created by Omkar Anarse on 29/12/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class InboxService {
    
    @Published var documentChanges = [DocumentChange]()
    
    func observeRecentMessage(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = FirestoreConstants
            .MessagesCollection
            .document(uid)
            .collection("recent-messages")
            .order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({
                $0.type == .added || $0.type == .modified
            }) else { return }
            
            self.documentChanges = changes
        }
    }
}
