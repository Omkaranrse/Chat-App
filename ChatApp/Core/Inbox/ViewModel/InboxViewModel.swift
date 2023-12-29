//
//  InboxViewModel.swift
//  ChatApp
//
//  Created by Omkar Anarse on 27/12/23.
//

import Foundation
import Firebase
import Combine
import SwiftUI
import FirebaseFirestore

class InboxViewModel : ObservableObject {
    
    @Published var currentUser : User?
    @Published var recentMessages = [Message]()
    
    private var cancellables = Set<AnyCancellable>()
    private var service = InboxService()
    
    init(){
        setUpSubscribers()
        service.observeRecentMessage()
    }
    
    private func setUpSubscribers(){
        UserService.shared.$currentUser.sink { [ weak self ] user in
            self?.currentUser = user
        }.store(in: &cancellables)
        
        service.$documentChanges.sink { [weak self] changes in
            self?.loadInitialMessages(fromChange: changes)
        }.store(in: &cancellables)
    }
    
    private func loadInitialMessages(fromChange changes : [DocumentChange]){
        var messages = changes.compactMap({ try? $0.document.data(as: Message.self)})
        
        for i in 0 ..< messages.count {
            let message = messages[i]
            
            UserService.fetchUser(withUid: message.chatPatnerID) { user in
                messages[i].user = user
                self.recentMessages.append(messages[i])
            }
        }
    }
}
