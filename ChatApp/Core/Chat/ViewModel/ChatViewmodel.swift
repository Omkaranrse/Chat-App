//
//  ChatViewmodel.swift
//  ChatApp
//
//  Created by Omkar Anarse on 28/12/23.
//

import Foundation

class ChatViewModel : ObservableObject {
    
    @Published var messageText : String = ""
    @Published var messages = [Message]()
    
    let service : ChatService
    
    init(user: User) {
        self.service = ChatService(chatPartner: user)
        observeMessages()
    }
    
    func sendMessage(){
        service.sendMessage(messageText)
    }
    
    func observeMessages(){
        service.observeMessages() { messages in
            self.messages.append(contentsOf: messages)
        }
    }
}
