//
//  NewMessageView.swift
//  ChatApp
//
//  Created by Omkar Anarse on 24/12/23.
//

import SwiftUI

struct NewMessageView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = NewMessageViewModel()
    @Binding var selectedUser : User?
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ScrollView {
                    
                    TextFieldWithIcon(systemName: "magnifyingglass", placeholder: "Search", text: $viewModel.searchUser, geometry: geometry)
                    
                    Text("CONTACTS")
                        .foregroundStyle(Color.gray)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    ForEach(viewModel.filteredUsers) { user in
                        VStack {
                            HStack {
                                CircularProfileImageView(user: user, size: .xSmall)
                                
                                Text(user.fullName ?? "")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                            .padding([.leading, .bottom])
                        }
                        .onTapGesture {
                            selectedUser = user
                            dismiss()
                        }
                    }
                }
                .navigationBarTitle("New Message")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundStyle(Color.black)
                    }
                })
            }
        }
    }
}

#Preview {
    NewMessageView(selectedUser: .constant(User.MOCK_USER))
}
