//
//  InboxRowView.swift
//  ChatApp
//
//  Created by Omkar Anarse on 24/12/23.
//

import SwiftUI
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

struct InboxRowView: View {
    
    let message : Message
    
    var body: some View {
        HStack (alignment: .top, spacing: 12){
            
            CircularProfileImageView(user: message.user, size: .large)

            VStack(alignment: .leading, spacing: 4) {
                Text(message.user?.fullName ?? "")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(message.messageText)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            
            HStack{
                Text(message.timestampString)
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundStyle(.gray)
        }
        .frame(height: 72)
    }
}

#Preview {
    InboxRowView(message: Message(fromID: "sahil", toID: "omkar", messageText: "hi", timestamp: Timestamp.init(date: Date()) ))
}
