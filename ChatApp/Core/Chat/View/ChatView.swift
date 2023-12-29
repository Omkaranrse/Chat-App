//
//  ChatView.swift
//  ChatApp
//
//  Created by Omkar Anarse on 24/12/23.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var viewModel : ChatViewModel
    
    let user : User
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                //header
                VStack{
                    CircularProfileImageView(user: user , size: .xLarge)
                    
                    VStack(spacing: 5) {
                        Text(user.fullName ?? "")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Messanger")
                            .font(.footnote)
                            .foregroundStyle(Color.gray)

                    }
                }
                
                //meassages
                LazyVStack{
                    ForEach(viewModel.messages){ message in
                        ChatMessageCell(message: message)
                    }
                }
            }
            
            
            //meassage input
            ZStack(alignment: .trailing) {
                TextField("Message...", text: $viewModel.messageText, axis: .vertical)
                    .padding(12)
                    .padding(.trailing, 48)
                    .background(Color(uiColor: .systemGroupedBackground))
                    .clipShape(Capsule())
                    .font(.subheadline)
                
                Button(action: {
                    viewModel.sendMessage()
                    viewModel.messageText = ""
                }, label: {
                    Text("Send")
                        .fontWeight(.semibold)
                })
                .padding(.horizontal)
            }
            .padding()
        }
//        .navigationTitle(user.fullName)
//        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChatView(user: User.MOCK_USER)
}
