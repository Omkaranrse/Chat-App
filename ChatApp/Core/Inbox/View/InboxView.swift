//
//  InboxView.swift
//  ChatApp
//
//  Created by Omkar Anarse on 24/12/23.
//

import SwiftUI

struct InboxView: View {
    
    @State private var newMessageView = false
    @StateObject var viewModel = InboxViewModel()
    @State private var selectedUser : User?
    @State private var showChat = false
    
    private var user : User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack {
            List{
                ActiveNowView()
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical)
                    .padding(.horizontal, 3)
                
                ForEach(viewModel.recentMessages) { message in
                    
                    ZStack {
                        NavigationLink(value: message) {
                            EmptyView()
                        }.opacity(0.0)
                        
                        InboxRowView(message: message)
//                            .listRowSeparator(.hidden)
//                            .listRowInsets(EdgeInsets())
//                            .padding(.vertical)
//                            .padding(.horizontal, 3)

                    }
                }
            }
            .listStyle(PlainListStyle())
            .onChange(of: selectedUser, perform: { newValue in
                showChat = newValue != nil
            })
            .navigationDestination(for: Message.self, destination: { message in
                if let user = message.user {
                    ChatView(user: user)
                }
            })
            .navigationDestination(for: Route.self, destination: { route in
                switch route {
                case .profile(let user):
                    ProfileView(user: user)
                case .chatView(let user):
                    ChatView(user: user)
                }
            })
            .navigationDestination(isPresented: $showChat, destination: {
                if let user = selectedUser {
                    ChatView(user: user)
                }
            })
            .fullScreenCover(isPresented: $newMessageView, content: {
                NewMessageView(selectedUser: $selectedUser)
            })
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    HStack {
                        if let user {
                            NavigationLink(value : Route.profile(user)) {
                                CircularProfileImageView(user: user, size: .xSmall)
                            }

                        }
                        Text("Chats")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        newMessageView.toggle()
                        selectedUser = nil
                    }, label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.black, Color(.systemGray5))
                    })
                }
            }
        }
    }
}

#Preview {
    InboxView()
}
