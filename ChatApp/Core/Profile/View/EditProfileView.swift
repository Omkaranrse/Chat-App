//
//  EditProfileView.swift
//  ChatApp
//
//  Created by Omkar Anarse on 29/12/23.
//

import PhotosUI
import Firebase
import SwiftUI
import FirebaseStorage
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct EditProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm: EditProfileViewModel
    @State private var isLoading = false
    
    init(user: User) {
        self._vm = StateObject(wrappedValue: EditProfileViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            //toolbar
            VStack {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    
                    Spacer()
                    
                    Text("Edit Profile")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            isLoading = true
                            try? await vm.updateUserData()
                            try? await vm.fetchUserData()
                            try? await Task.sleep(nanoseconds: 3 * 1_000_000_000) // Sleep for 3 seconds
                            isLoading = false
                            dismiss()
                        }
                    }, label: {
                        Text("Done")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    })
                }
                .padding(.horizontal)
                
                Divider()
            }
            
            //Edit profile Picture
            PhotosPicker(selection: $vm.selectedImage) {
                VStack(spacing: 8) {
                    if let image = vm.profileImageUrl {
                        image
                            .resizable()
                            .foregroundColor(Color.white)
                            .background(Color.gray)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())

                    } else {
                        CircularProfileImageView(user: vm.user, size: .large)
                    }
                    
                    Text("Edit profile picture")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Divider()
                }
            }
            
            //Edit profile info
            VStack {
                EditProfileRowView(title: "Name", placeholder: "Enter your name...", text: $vm.fullName)
                
                Spacer()
            }
            
        }
        .overlay {
            Group {
                if isLoading {
                    // Show circular progress view
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                        .ignoresSafeArea()
                } else {
                    EmptyView()
                }
            }
        }
    }
}

struct EditProfileRowView: View {
    
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(title)
                .padding(.leading, 8)
                .frame(width: 100, alignment: .leading)
            
            VStack {
                TextField(placeholder, text: $text)
                
                Divider()
            }
        }
        .font(.subheadline)
        .frame(height: 36)
    }
}

#Preview(body: {
    EditProfileView(user: User(fullName: "omkar", email: "omakr@gmail.com"))
})
